//
//  CertificateRepository.swift
//  Zalex
//

import Foundation
import Combine

protocol CertificateRepositoryProtocol: AnyObject {
    var requestsPublisher: AnyPublisher<[CertificateRequest], Never> { get }
    func fetchRequests() async throws
    func submitRequest(_ body: CertificateRequestSubmitBody) async throws
    func updateLocalRequest(id: UUID, purpose: String)
}

final class CertificateRepository: CertificateRepositoryProtocol, ObservableObject {
    private let apiClient: APIClientProtocol
    private let requestsSubject = CurrentValueSubject<[CertificateRequest], Never>([])

    var requestsPublisher: AnyPublisher<[CertificateRequest], Never> {
        requestsSubject.eraseToAnyPublisher()
    }

    init(apiClient: APIClientProtocol = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchRequests() async throws {
        let list: [CertificateRequest] = try await apiClient.get(endpoint: .requestList)
        requestsSubject.send(list)
    }

    func submitRequest(_ body: CertificateRequestSubmitBody) async throws {
        let _: CertificateSubmitResponse     = try await apiClient.post(endpoint: .requestCertificate, body: body)
        var newRequest = CertificateRequest(
            addressTo: body.addressTo,
            purpose: body.purpose,
            issuedOn: body.issuedOn,
            employeeId: body.employeeId,
            status: "New"
        )
        var current = requestsSubject.value
        current.insert(newRequest, at: 0)
        requestsSubject.send(current)
    }

    func updateLocalRequest(id: UUID, purpose: String) {
        var current = requestsSubject.value
        guard let index = current.firstIndex(where: { $0.id == id }) else { return }
        current[index].purpose = purpose
        requestsSubject.send(current)
    }
}
