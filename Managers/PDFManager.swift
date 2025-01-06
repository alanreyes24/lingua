import Foundation
import SwiftUI
import SwiftData
import AppKit
import UniformTypeIdentifiers

class PDFManager: ObservableObject {

    let modelContext: ModelContext
    
    // MARK: - Initialization
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Public Method to Present PDF Picker
    /// Call this method from your SwiftUI View to present the PDF picker as a sheet.
    /// Example:
    /// ```
    /// .sheet(isPresented: $showPicker) {
    ///     pdfManager.openPDFPanel { url in
    ///         // Handle the picked PDF URL here
    ///     }
    /// }
    /// ```
    func openPDFPanel(onPickPDF: @escaping (URL) -> Void) -> some View {
        PDFPicker(onPickPDF: onPickPDF)
    }
    
    // MARK: - Nested NSViewControllerRepresentable
    /// A private struct that actually handles showing the NSOpenPanel for PDFs.
    private struct PDFPicker: NSViewControllerRepresentable {
        
        let onPickPDF: (URL) -> Void
        
        func makeNSViewController(context: Context) -> NSViewController {
            // Create a generic NSViewController that immediately launches NSOpenPanel
            let viewController = NSViewController()
            
            DispatchQueue.main.async {
                let panel = NSOpenPanel()
                // Use allowedContentTypes instead of deprecated allowedFileTypes
                panel.allowedContentTypes = [UTType.pdf]
                panel.allowsMultipleSelection = false
                panel.begin { response in
                    if response == .OK, let url = panel.urls.first {
                        onPickPDF(url)
                    }
                }
            }
            
            return viewController
        }
        
        func updateNSViewController(_ nsViewController: NSViewController, context: Context) {
            // No updates needed
        }
    }
}
