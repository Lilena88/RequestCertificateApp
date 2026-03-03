//
//  CertificateRequest.swift
//  Zalex
//

import Foundation

struct CertificateRequest: Codable, Identifiable, Equatable, Hashable {
    let id: UUID
    var referenceNo: Int?
    var addressTo: String
    var purpose: String
    var issuedOn: String
    var employeeId: String?
    var status: String?

    enum CodingKeys: String, CodingKey {
        case referenceNo = "reference_no"
        case addressTo = "address_to"
        case purpose
        case issuedOn = "issued_on"
        case employeeId = "employee_id"
        case status
    }

    init(
        id: UUID = UUID(),
        referenceNo: Int? = nil,
        addressTo: String,
        purpose: String,
        issuedOn: String,
        employeeId: String,
        status: String? = nil
    ) {
        self.id = id
        self.referenceNo = referenceNo
        self.addressTo = addressTo
        self.purpose = purpose
        self.issuedOn = issuedOn
        self.employeeId = employeeId
        self.status = status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = UUID()
        referenceNo = try container.decodeIfPresent(Int.self, forKey: .referenceNo)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        addressTo = try container.decode(String.self, forKey: .addressTo)
        issuedOn = try container.decode(String.self, forKey: .issuedOn)
        employeeId = try container.decodeIfPresent(String.self, forKey: .employeeId)
        purpose = try container.decode(String.self, forKey: .purpose)
       
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(referenceNo, forKey: .referenceNo)
        try container.encode(addressTo, forKey: .addressTo)
        try container.encode(purpose, forKey: .purpose)
        try container.encode(issuedOn, forKey: .issuedOn)
        try container.encode(employeeId, forKey: .employeeId)
        try container.encodeIfPresent(status, forKey: .status)
    }
}

/// Request body for POST request-certificate endpoint.
struct CertificateRequestSubmitBody: Encodable {
    let addressTo: String
    let purpose: String
    let issuedOn: String
    let employeeId: String

    enum CodingKeys: String, CodingKey {
        case addressTo = "address_to"
        case purpose
        case issuedOn = "issued_on"
        case employeeId = "employee_id"
    }
}
