//
//  RequestsListViewModelTests.swift
//  ZalexTests
//

import Testing
import Foundation
@testable import Zalex

@MainActor
struct RequestsListViewModelTests {

    @Test func filteredRequests_appliesSearchByReferenceNo() async {
        let repo = MockCertificateRepository()
        let req1 = CertificateRequest(referenceNo: 1001, addressTo: "A", purpose: "P", issuedOn: "1/1/2024", employeeId: "1", status: "New")
        let req2 = CertificateRequest(referenceNo: 1002, addressTo: "B", purpose: "P", issuedOn: "1/2/2024", employeeId: "2", status: "Done")
        repo.setRequests([req1, req2])
        await Task.yield()

        let vm = RequestsListViewModel(repository: repo)
        await Task.yield()
        vm.searchText = "1001"

        #expect(vm.filteredRequests.count == 1)
        #expect(vm.filteredRequests[0].referenceNo == 1001)
    }

    @Test func filteredRequests_appliesSearchByStatus() async {
        let repo = MockCertificateRepository()
        let req1 = CertificateRequest(referenceNo: 1, addressTo: "A", purpose: "P", issuedOn: "1/1/2024", employeeId: "1", status: "New")
        let req2 = CertificateRequest(referenceNo: 2, addressTo: "B", purpose: "P", issuedOn: "1/2/2024", employeeId: "2", status: "Done")
        repo.setRequests([req1, req2])
        await Task.yield()

        let vm = RequestsListViewModel(repository: repo)
        await Task.yield()
        vm.searchText = "Done"

        #expect(vm.filteredRequests.count == 1)
        #expect(vm.filteredRequests[0].status == "Done")
    }

    @Test func filteredRequests_sortsByIssuedOn() async {
        let repo = MockCertificateRepository()
        let req1 = CertificateRequest(referenceNo: 1, addressTo: "A", purpose: "P", issuedOn: "1/1/2024", employeeId: "1", status: "New")
        let req2 = CertificateRequest(referenceNo: 2, addressTo: "B", purpose: "P", issuedOn: "1/3/2024", employeeId: "2", status: "New")
        repo.setRequests([req1, req2])
        await Task.yield()

        let vm = RequestsListViewModel(repository: repo)
        await Task.yield()
        vm.sortOption = .issuedOn

        #expect(vm.filteredRequests.count == 2)
        #expect(vm.filteredRequests[0].issuedOn == "1/3/2024")
        #expect(vm.filteredRequests[1].issuedOn == "1/1/2024")
    }

    @Test func loadRequests_whenRepositoryThrows_setsErrorMessage() async {
        let repo = MockCertificateRepository()
        repo.fetchRequestsError = APIError.decodingError
        let vm = RequestsListViewModel(repository: repo)

        await vm.loadRequests()

        #expect(vm.errorMessage != nil)
    }
}
