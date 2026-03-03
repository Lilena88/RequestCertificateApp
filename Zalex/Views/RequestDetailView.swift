//
//  RequestDetailView.swift
//  Zalex
//

import SwiftUI

struct RequestDetailView: View {
    @ObservedObject var viewModel: RequestDetailViewModel
    @State private var showPDFFullScreen = false
    
    var body: some View {
        List {
            Section("Request") {
                if let ref = viewModel.request.referenceNo {
                    LabeledRow(label: "Reference No.", value: String(ref))
                }
                LabeledRow(label: "Address to", value: viewModel.request.addressTo)
                if viewModel.canEdit {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Purpose")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        TextField("Purpose", text: $viewModel.editedPurpose, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)
                    }
                } else {
                    LabeledRow(label: "Purpose", value: viewModel.request.purpose)
                }
                if viewModel.request.status == "Done" {
                    LabeledRow(label: "Issued on", value: viewModel.request.issuedOn)
                }
                LabeledRow(label: "Status", value: viewModel.request.status ?? "—")
            }
            Section("Certificate") {
                if viewModel.request.status == "Done" {
                    if viewModel.pdfData != nil {
                        Button {
                            showPDFFullScreen = true
                        } label: {
                            Label("Open certificate pdf", systemImage: "doc.fill")
                        }
                    } else {
                        Text("Certificate is yet to be issued.")
                            .foregroundStyle(.secondary)
                    }
                } else {
                    Text("Certificate is yet to be issued.")
                        .foregroundStyle(.secondary)
                }
            }
            if viewModel.canEdit {
                Section {
                    Button {
                        viewModel.save()
                    } label: {
                        HStack {
                            Spacer()
                            if viewModel.isSaving {
                                ProgressView()
                            } else {
                                Text("Save")
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                    .disabled(viewModel.isSaving || viewModel.editedPurpose == viewModel.request.purpose)
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 0) }
        .ignoresSafeArea(.keyboard, edges: [])
        .navigationTitle("Request Details")
        .fullScreenCover(isPresented: $showPDFFullScreen) {
            NavigationStack {
                PDFPreviewView(data: viewModel.pdfData, fileName: viewModel.pdfFileName ?? "certificate.pdf")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                showPDFFullScreen = false
                            }
                        }
                    }
            }
        }
    }
}

private struct LabeledRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
        }
    }
}
