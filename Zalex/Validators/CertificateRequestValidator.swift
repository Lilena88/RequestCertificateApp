//
//  CertificateRequestValidator.swift
//  Zalex
//

import Foundation

struct ValidationError {
    let field: String
    let message: String
}

enum CertificateRequestValidator {
    private static let purposeMinimumLength = 50
    private static let alphanumericCharacterSet = CharacterSet.alphanumerics.union(.whitespaces)
    private static let decimalDigitSet = CharacterSet.decimalDigits

    static func validate(
        addressTo: String,
        purpose: String,
        issuedOn: Date,
        employeeId: String
    ) -> [ValidationError] {
        var errors: [ValidationError] = []

        if addressTo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append(ValidationError(field: "addressTo", message: NSLocalizedString("Address to is required.", comment: "Validation")))
        } else if !addressTo.unicodeScalars.allSatisfy({ alphanumericCharacterSet.contains($0) }) {
            errors.append(ValidationError(field: "addressTo", message: NSLocalizedString("Address to must be alphanumeric.", comment: "Validation")))
        }

        if purpose.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append(ValidationError(field: "purpose", message: NSLocalizedString("Purpose is required.", comment: "Validation")))
        } else if purpose.count < purposeMinimumLength {
            errors.append(ValidationError(field: "purpose", message: String(format: NSLocalizedString("Purpose must be at least %d characters.", comment: "Validation"), purposeMinimumLength)))
        }

        let calendar = Calendar.current
        let issuedDay = calendar.startOfDay(for: issuedOn)
        let today = calendar.startOfDay(for: Date())
        if issuedDay <= today {
            errors.append(ValidationError(field: "issuedOn", message: NSLocalizedString("Issued on must be a future date.", comment: "Validation")))
        }

        if employeeId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append(ValidationError(field: "employeeId", message: NSLocalizedString("Employee ID is required.", comment: "Validation")))
        } else if !employeeId.unicodeScalars.allSatisfy({ decimalDigitSet.contains($0) }) {
            errors.append(ValidationError(field: "employeeId", message: NSLocalizedString("Employee ID must be numeric only.", comment: "Validation")))
        }

        return errors
    }
}
