//
//  GPTManager.swift
//  Lingua
//
//  Created by Alan Reyes on 12/28/24.
//

import Foundation
import SwiftData
import PDFKit

class GPTManager: ObservableObject {
    
    let modelContext: ModelContext
    private var apiKey: String {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dictionary = NSDictionary(contentsOfFile: path),
              let key = dictionary["OPENAI_API_KEY"] as? String else {
            fatalError("API Key not found in Secrets.plist")
        }
        return key
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func sendMessageToGPT(userInput: String, completion: @escaping (String?) -> Void) {
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let messages: [[String: String]] = [
            [
                "role": "system",
                "content": """
                You are processing word translations from one language into another. You must provide your output strictly as valid JSON, with no additional text, formatting, or explanations. Each JSON key must be a non-English word, and its corresponding value must be the correct English translation(s). If a translation is obviously incorrect, replace it with the correct one. If there are multiple valid translations, include only the two most commonly used ones, separated by a slash (e.g., “word1/word2”). Do not include anything but the JSON object itself in your response. Make sure you do NOT SKIP over any words.
                """
            ],
            ["role": "user", "content": userInput]
        ]

        let requestBody: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": messages
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Failed to serialize JSON: \(error.localizedDescription)")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }

            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                // Check for API error messages
                if let error = jsonResponse?["error"] as? [String: Any],
                   let errorMessage = error["message"] as? String {
                    print("API Error: \(errorMessage)")
                    completion(nil)
                    return
                }

                
                // Decode valid response
                if let choices = jsonResponse?["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(content)
                } else {
                    print("Unexpected JSON structure.")
                    completion(nil)
                }
            } catch {
                print("Failed to parse JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        task.resume()
    }
    
    func extractText (from pdfURL: URL) -> String? {
        
        guard let pdfDocument = PDFDocument(url: pdfURL) else {
            print("Could not load pdf document")
            return nil
        }
        
        let pageCount = pdfDocument.pageCount
        var pdfText = ""
    
        for pageIndex in 0..<pageCount {
            guard let page = pdfDocument.page(at: pageIndex),
                  let pageText = page.string else {
                continue
            }
            pdfText += pageText + "\n"
        }
        
        return pdfText
        
    }
    
    func sendPDFtoGPT(pdfURL: URL, completion: @escaping (String?) -> Void) {
        
        guard let pdfText = extractText(from: pdfURL) else {
            completion(nil)
            return
        }

        // 2. Pass the extracted text to our existing function
        sendMessageToGPT(userInput: pdfText, completion: completion)
    }

}

