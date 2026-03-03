//
//  ValidatedTextField.swift
//  Zalex
//

import SwiftUI

struct ValidatedTextField: View {
    let label: String
    @Binding var text: String
    let errorMessage: String?
    let axis: Axis
    let keyboardType: UIKeyboardType

    init(
        label: String,
        text: Binding<String>,
        errorMessage: String? = nil,
        axis: Axis = .vertical,
        keyboardType: UIKeyboardType = .default
    ) {
        self.label = label
        self._text = text
        self.errorMessage = errorMessage
        self.axis = axis
        self.keyboardType = keyboardType
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            TextField(label, text: $text, axis: axis)
                .textFieldStyle(.roundedBorder)
                .keyboardType(keyboardType)
                .accessibilityLabel(label)
                .accessibilityHint(errorMessage ?? "")
            if let error = errorMessage, !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .accessibilityElement(children: .combine)
            }
        }
    }
}

#Preview {
    ValidatedTextField(
        label: "Purpose",
        text: .constant(""),
        errorMessage: "Purpose must be at least 50 characters."
    )
    .padding()
}
