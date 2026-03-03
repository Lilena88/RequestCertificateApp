//
//  RequestFormViewModel.swift
//  Zalex
//

import Foundation
import Combine

final class RequestFormViewModel: ObservableObject {
    @Published var addressTo = ""
    @Published var purpose = ""
    @Published var issuedOn = Date()
    @Published var employeeId = ""
    @Published var fieldErrors: [String: String] = [:]
    @Published var isSubmitting = false
    @Published var showSuccessAlert = false
    @Published var errorMessage: String?

    private let repository: CertificateRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: CertificateRepositoryProtocol) {
        self.repository = repository
    }

    func validate() -> Bool {
        let errors = CertificateRequestValidator.validate(
            addressTo: addressTo,
            purpose: purpose,
            issuedOn: issuedOn,
            employeeId: employeeId
        )
        fieldErrors = Dictionary(uniqueKeysWithValues: errors.map { ($0.field, $0.message) })
        return errors.isEmpty
    }

    @MainActor
    func submit() async {
        guard validate() else { return }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }

        let body = CertificateRequestSubmitBody(
            addressTo: addressTo.trimmingCharacters(in: .whitespacesAndNewlines),
            purpose: purpose.trimmingCharacters(in: .whitespacesAndNewlines),
            issuedOn: issuedOn.apiFormatted,
            employeeId: employeeId.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        do {
            try await repository.submitRequest(body)
            showSuccessAlert = true
            resetForm()
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func resetForm() {
        addressTo = ""
        purpose = ""
        issuedOn = Date()
        employeeId = ""
        fieldErrors = [:]
    }
}
