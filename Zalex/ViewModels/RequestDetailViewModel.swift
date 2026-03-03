//
//  RequestDetailViewModel.swift
//  Zalex
//

import Foundation
import Combine

final class RequestDetailViewModel: ObservableObject {
    @Published var request: CertificateRequest
    @Published var editedPurpose: String
    @Published var isSaving = false
    @Published var errorMessage: String?

    var canEdit: Bool {
        request.status == "New"
    }

    private var bundledPDFURL: URL? {
        Bundle.main.url(forResource: "sample_certificate_of_employment", withExtension: "pdf")
    }

    var pdfData: Data? {
        guard request.status == "Done", let url = bundledPDFURL else { return nil }
        return try? Data(contentsOf: url)
    }

    var pdfFileName: String? {
        guard request.status == "Done", let url = bundledPDFURL else { return nil }
        return url.lastPathComponent
    }

    private let repository: CertificateRepositoryProtocol

    init(request: CertificateRequest, repository: CertificateRepositoryProtocol) {
        self.request = request
        self.editedPurpose = request.purpose
        self.repository = repository
    }

    @MainActor
    func save() {
        guard canEdit else { return }
        isSaving = true
        errorMessage = nil
        repository.updateLocalRequest(id: request.id, purpose: editedPurpose)
        request.purpose = editedPurpose
        isSaving = false
    }

}
