//
//  RequestsListViewModel.swift
//  Zalex
//

import Foundation
import Combine

enum RequestSortOption: String, CaseIterable {
    case issuedOn = "Issued on"
    case status = "Status"
}

final class RequestsListViewModel: ObservableObject {
    @Published var requests: [CertificateRequest] = []
    @Published var searchText = ""
    @Published var sortOption: RequestSortOption = .issuedOn
    @Published var filterStatus: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    var filteredRequests: [CertificateRequest] {
        var result = requests

        if !searchText.isEmpty {
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            let queryLower = query.lowercased()
            let words = queryLower.split(separator: " ").map(String.init)
            result = result.filter { request in
                if let ref = request.referenceNo, let queryInt = Int(query), ref == queryInt { return true }
                if (request.status ?? "").lowercased() == queryLower { return true }
                if !words.isEmpty, words.allSatisfy({ request.addressTo.lowercased().contains($0) }) { return true }
                return false
            }
        }

        if !filterStatus.isEmpty {
            result = result.filter { $0.status == filterStatus }
        }

        switch sortOption {
        case .issuedOn:
            result.sort { lhs, rhs in
                lhs.issuedOn.compare(rhs.issuedOn, options: .numeric) == .orderedDescending
            }
        case .status:
            result.sort { ($0.status ?? "").localizedCompare($1.status ?? "") == .orderedAscending }
        }

        return result
    }

    private let repository: CertificateRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: CertificateRepositoryProtocol) {
        self.repository = repository
        repository.requestsPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$requests)
    }

    @MainActor
    func loadRequests() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            try await repository.fetchRequests()
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
