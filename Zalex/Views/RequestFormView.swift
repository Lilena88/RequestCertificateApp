//
//  RequestFormView.swift
//  Zalex
//

import SwiftUI

struct RequestFormView: View {
    @ObservedObject var viewModel: RequestFormViewModel

    var body: some View {
        Form {
            ValidatedTextField(
                label: NSLocalizedString("Address to", comment: "Form field"),
                text: $viewModel.addressTo,
                errorMessage: viewModel.fieldErrors["addressTo"],
                axis: .vertical
            )
            ValidatedTextField(
                label: NSLocalizedString("Purpose", comment: "Form field"),
                text: $viewModel.purpose,
                errorMessage: viewModel.fieldErrors["purpose"],
                axis: .vertical
            )
            VStack(alignment: .leading, spacing: 4) {
                Text("Issued on")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                DatePicker(
                    "Issued on",
                    selection: $viewModel.issuedOn,
                    in: Calendar.current.date(byAdding: .day, value: 1, to: Date())!...,
                    displayedComponents: .date
                )
                .labelsHidden()
                if let error = viewModel.fieldErrors["issuedOn"] {
                    Text(error)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            ValidatedTextField(
                label: NSLocalizedString("Employee ID", comment: "Form field"),
                text: $viewModel.employeeId,
                errorMessage: viewModel.fieldErrors["employeeId"],
                keyboardType: .numberPad
            )
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) {
            Button {
                Task { await viewModel.submit() }
            } label: {
                HStack {
                    Spacer()
                    if viewModel.isSubmitting {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Submit")
                            .fontWeight(.semibold)
                    }
                    Spacer()
                }
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isSubmitting)
            .padding(.horizontal)
            .padding(.bottom, 8)
            .background(.bar)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder),
                to: nil, from: nil, for: nil
            )
        }
        .navigationTitle("Request Certificate")
        .alert("Success", isPresented: $viewModel.showSuccessAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your certificate request has been submitted.")
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
