//
//  CertificateRequestValidatorTests.swift
//  ZalexTests
//

import Testing
import Foundation
@testable import Zalex

struct CertificateRequestValidatorTests {

    @Test func validate_emptyAddressTo_returnsError() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            employeeId: "123456"
        )
        #expect(errors.contains { $0.field == "addressTo" })
    }

    @Test func validate_alphanumericAddressTo_passes() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy of Neptun 123",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            employeeId: "123456"
        )
        #expect(!errors.contains { $0.field == "addressTo" })
    }

    @Test func validate_nonAlphanumericAddressTo_returnsError() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy @ Neptun!",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            employeeId: "123456"
        )
        #expect(errors.contains { $0.field == "addressTo" })
    }

    @Test func validate_purposeUnder50Chars_returnsError() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy",
            purpose: String(repeating: "x", count: 49),
            issuedOn: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            employeeId: "123456"
        )
        #expect(errors.contains { $0.field == "purpose" })
    }

    @Test func validate_purposeExactly50Chars_passes() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            employeeId: "123456"
        )
        #expect(!errors.contains { $0.field == "purpose" })
    }

    @Test func validate_pastDate_returnsError() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
            employeeId: "123456"
        )
        #expect(errors.contains { $0.field == "issuedOn" })
    }

    @Test func validate_today_returnsError() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Date(),
            employeeId: "123456"
        )
        #expect(errors.contains { $0.field == "issuedOn" })
    }

    @Test func validate_futureDate_passes() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            employeeId: "123456"
        )
        #expect(!errors.contains { $0.field == "issuedOn" })
    }

    @Test func validate_emptyEmployeeId_returnsError() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            employeeId: ""
        )
        #expect(errors.contains { $0.field == "employeeId" })
    }

    @Test func validate_nonNumericEmployeeId_returnsError() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy",
            purpose: String(repeating: "x", count: 50),
            issuedOn: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            employeeId: "12a456"
        )
        #expect(errors.contains { $0.field == "employeeId" })
    }

    @Test func validate_allValid_returnsNoErrors() {
        let errors = CertificateRequestValidator.validate(
            addressTo: "Embassy of Neptun",
            purpose: String(repeating: "Visa Application text. ", count: 3),
            issuedOn: Calendar.current.date(byAdding: .day, value: 7, to: Date())!,
            employeeId: "123456"
        )
        #expect(errors.isEmpty)
    }
}
