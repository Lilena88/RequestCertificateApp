//
//  RequestFormViewModelTests.swift
//  ZalexTests
//

import Testing
import Foundation
@testable import Zalex

@MainActor
struct RequestFormViewModelTests {

    @Test func validate_withInvalidData_returnsFalse() {
        let repo = MockCertificateRepository()
        let vm = RequestFormViewModel(repository: repo)
        vm.addressTo = ""
        vm.purpose = "short"
        vm.employeeId = "abc"
        let valid = vm.validate()
        #expect(valid == false)
        #expect(!vm.fieldErrors.isEmpty)
    }

    @Test func validate_withValidData_returnsTrue() {
        let repo = MockCertificateRepository()
        let vm = RequestFormViewModel(repository: repo)
        vm.addressTo = "Embassy"
        vm.purpose = String(repeating: "x", count: 50)
        vm.issuedOn = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        vm.employeeId = "123456"
        let valid = vm.validate()
        #expect(valid == true)
        #expect(vm.fieldErrors.isEmpty)
    }

    @Test func submit_whenValid_callsRepositoryAndShowsSuccess() async {
        let repo = MockCertificateRepository()
        let vm = RequestFormViewModel(repository: repo)
        vm.addressTo = "Embassy"
        vm.purpose = String(repeating: "x", count: 50)
        vm.issuedOn = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        vm.employeeId = "123456"

        await vm.submit()

        #expect(repo.submittedBodies.count == 1)
        #expect(repo.submittedBodies[0].addressTo == "Embassy")
        #expect(repo.submittedBodies[0].employeeId == "123456")
        #expect(vm.showSuccessAlert == true)
    }

    @Test func submit_whenRepositoryThrows_setsErrorMessage() async {
        let repo = MockCertificateRepository()
        repo.submitRequestError = APIError.networkError(NSError(domain: "test", code: -1, userInfo: nil))
        let vm = RequestFormViewModel(repository: repo)
        vm.addressTo = "Embassy"
        vm.purpose = String(repeating: "x", count: 50)
        vm.issuedOn = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        vm.employeeId = "123456"

        await vm.submit()

        #expect(vm.errorMessage != nil)
        #expect(vm.showSuccessAlert == false)
    }
}
