//
//  ContentView.swift
//  Zalex
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var repository: CertificateRepository

    var body: some View {
        TabView {
            NavigationStack {
                RequestFormView(viewModel: RequestFormViewModel(repository: repository))
            }
            .tabItem {
                Label("New Request", systemImage: "doc.badge.plus")
            }
            NavigationStack {
                RequestsListView(viewModel: RequestsListViewModel(repository: repository))
                    .navigationDestination(for: CertificateRequest.self) { request in
                        RequestDetailView(viewModel: RequestDetailViewModel(request: request, repository: repository))
                    }
            }
            .tabItem {
                Label("My Requests", systemImage: "list.bullet")
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(CertificateRepository())
}
