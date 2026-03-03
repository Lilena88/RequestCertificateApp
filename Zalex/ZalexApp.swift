//
//  ZalexApp.swift
//  Zalex
//
//  Created by Elena Kim on 01/03/2026.
//

import SwiftUI

@main
struct ZalexApp: App {
    private let repository = CertificateRepository()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(repository)
        }
    }
}
