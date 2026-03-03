//
//  MockCertificateRepository.swift
//  ZalexTests
//

import Foundation
import Combine
@testable import Zalex

final class MockCertificateRepository: CertificateRepositoryProtocol {
    private let subject = CurrentValueSubject<[CertificateRequest], Never>([])

    var requestsPublisher: AnyPublisher<[CertificateRequest], Never> {
        subject.eraseToAnyPublisher()
    }

    var fetchRequestsError: Error?
    var submitRequestError: Error?
    var submittedBodies: [CertificateRequestSubmitBody] = []
    var updateLocalRequestCalls: [(id: UUID, purpose: String)] = []

    func setRequests(_ requests: [CertificateRequest]) {
        subject.send(requests)
    }

    func fetchRequests() async throws {
        if let error = fetchRequestsError {
            throw error
        }
    }

    func submitRequest(_ body: CertificateRequestSubmitBody) async throws {
        submittedBodies.append(body)
        if let error = submitRequestError {
            throw error
        }
        var newRequest = CertificateRequest(
            addressTo: body.addressTo,
            purpose: body.purpose,
            issuedOn: body.issuedOn,
            employeeId: body.employeeId,
            status: "New"
        )
        var current = subject.value
        current.insert(newRequest, at: 0)
        subject.send(current)
    }

    func updateLocalRequest(id: UUID, purpose: String) {
        updateLocalRequestCalls.append((id, purpose))
        var current = subject.value
        guard let index = current.firstIndex(where: { $0.id == id }) else { return }
        current[index].purpose = purpose
        subject.send(current)
    }
}
