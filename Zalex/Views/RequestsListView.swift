//
//  RequestsListView.swift
//  Zalex
//

import SwiftUI

struct RequestsListView: View {
    @ObservedObject var viewModel: RequestsListViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("Loading…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.filteredRequests) { request in
                    NavigationLink(value: request) {
                        RequestRowView(request: request)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("My Requests")
        .searchable(text: $viewModel.searchText, prompt: "Reference, address, or status")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Picker("Sort", selection: $viewModel.sortOption) {
                    ForEach(RequestSortOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .task {
            if viewModel.requests.isEmpty {
                await viewModel.loadRequests()
            }
        }
        .alert("Error", isPresented: Binding(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {
                viewModel.errorMessage = nil
            }
        } message: {
            if let msg = viewModel.errorMessage {
                Text(msg)
            }
        }
    }
}

struct RequestRowView: View {
    let request: CertificateRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                if let ref = request.referenceNo {
                    Text(String(ref))
                        .font(.headline)
                }
                Spacer()
                StatusBadge(status: request.status ?? "—")
            }
            Text(request.addressTo)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            if !request.purpose.isEmpty {
                Text(request.purpose)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(2)
            }
            if !request.issuedOn.isEmpty {
                Text(request.issuedOn)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
