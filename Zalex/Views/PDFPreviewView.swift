//
//  PDFPreviewView.swift
//  Zalex
//

import SwiftUI
import PDFKit

struct PDFPreviewView: View {
    let data: Data?
    var fileName: String = "certificate.pdf"
    @State private var tempFileURL: URL?

    var body: some View {
        Group {
            if let data = data {
                PDFKitRepresentable(data: data)
                    .frame(minHeight: 400)
            }
        }
        .onAppear {
            prepareFileForSharing()
        }
        .onDisappear {
            removeTempFile()
        }
        .onChange(of: data) { _ in
            removeTempFile()
            prepareFileForSharing()
        }
        .toolbar {
            if tempFileURL != nil {
                ToolbarItem(placement: .primaryAction) {
                    ShareLink(
                        item: tempFileURL!,
                        subject: Text("Certificate"),
                        message: Text("Certificate PDF")
                    ) {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                }
            }
        }
    }

    private func prepareFileForSharing() {
        guard let data = data else { return }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? data.write(to: url)
        tempFileURL = url
    }

    private func removeTempFile() {
        guard let url = tempFileURL else { return }
        try? FileManager.default.removeItem(at: url)
        tempFileURL = nil
    }
}

private struct PDFKitRepresentable: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        if let document = PDFDocument(data: data) {
            view.document = document
        }
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        if let document = PDFDocument(data: data) {
            uiView.document = document
        }
    }
}
