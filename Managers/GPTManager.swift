//
//  GPTManager.swift
//  Lingua
//
//  Created by Alan Reyes on 12/28/24.
//

import Foundation
import SwiftData

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
            ["role": "system", "content": "You are processing word translations from one language into another. Your task is to output the translations in a JSON format, structured as key-value pairs. The key should always be the non-English word, and the value should be the English translation(s). If the translation provided is clearly incorrect, replace it with the correct one. If there are multiple valid translations, include the two most commonly used ones, separated by a slash (e.g., ‘word1/word2’). Ensure the output follows these rules strictly, with English words ALWAYS appearing as the key."],
            ["role": "user", "content": userInput]
        ]

        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
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
}
