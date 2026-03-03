//
//  ZalexTests.swift
//  ZalexTests
//
//  Created by Elena Kim on 01/03/2026.
//

import Testing
import Combine
@testable import Zalex

struct ZalexTests {

    @Test func repository_fetchRequests_publishesFromAPIClient() async throws {
        let mockClient = MockAPIClient()
        let requests: [CertificateRequest] = [
            CertificateRequest(addressTo: "A", purpose: "P", issuedOn: "1/1/2024", employeeId: "1")
        ]
        mockClient.getResult = { requests }
        let repo = CertificateRepository(apiClient: mockClient)
        var received: [CertificateRequest] = []
        let c = repo.requestsPublisher.sink { received = $0 }

        try await repo.fetchRequests()

        #expect(mockClient.getCallCount == 1)
        #expect(received.count == 1)
        #expect(received[0].addressTo == "A")
        c.cancel()
    }
}
