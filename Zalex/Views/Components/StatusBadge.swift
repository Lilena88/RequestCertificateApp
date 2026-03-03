//
//  StatusBadge.swift
//  Zalex
//

import SwiftUI

struct StatusBadge: View {
    let status: String

    var body: some View {
        Text(status)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundStyle(statusColor)
            .clipShape(Capsule())
    }

    private var statusColor: Color {
        switch status.lowercased() {
        case "done": return .green
        case "new": return .blue
        default: return .secondary
        }
    }
}

#Preview {
    HStack {
        StatusBadge(status: "New")
        StatusBadge(status: "Done")
    }
}
