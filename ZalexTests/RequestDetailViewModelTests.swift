//
//  RequestDetailViewModelTests.swift
//  ZalexTests
//

import Testing
import Foundation
@testable import Zalex

@MainActor
struct RequestDetailViewModelTests {

    @Test func canEdit_whenStatusNew_returnsTrue() {
        let repo = MockCertificateRepository()
        let request = CertificateRequest(referenceNo: 1, addressTo: "A", purpose: "Purpose text here", issuedOn: "1/1/2024", employeeId: "1", status: "New")
        let vm = RequestDetailViewModel(request: request, repository: repo)
        #expect(vm.canEdit == true)
    }

    @Test func canEdit_whenStatusDone_returnsFalse() {
        let repo = MockCertificateRepository()
        let request = CertificateRequest(referenceNo: 1, addressTo: "A", purpose: "P", issuedOn: "1/1/2024", employeeId: "1", status: "Done")
        let vm = RequestDetailViewModel(request: request, repository: repo)
        #expect(vm.canEdit == false)
    }

    @Test func save_callsRepositoryUpdateLocalRequest() {
        let repo = MockCertificateRepository()
        let request = CertificateRequest(referenceNo: 1, addressTo: "A", purpose: "Old purpose", issuedOn: "1/1/2024", employeeId: "1", status: "New")
        repo.setRequests([request])
        let vm = RequestDetailViewModel(request: request, repository: repo)
        vm.editedPurpose = "New purpose"

        vm.save()

        #expect(repo.updateLocalRequestCalls.count == 1)
        #expect(repo.updateLocalRequestCalls[0].id == request.id)
        #expect(repo.updateLocalRequestCalls[0].purpose == "New purpose")
    }
}
