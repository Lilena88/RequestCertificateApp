# Zalex — Employee Certification MVP

Native iOS app (SwiftUI) for requesting and managing employment certificates. Built for iOS 16.0+.

## API key

The app calls Zalex REST APIs that require a subscription key.

- **Environment variable**  
  Set `ZALEX_API_KEY` before launching the app, e.g. in Xcode scheme:
  - Edit Scheme → Run → Arguments → Environment Variables.
  - Add: `ZALEX_API_KEY` = `<your subscription key>`.

The key is read in `APIConfiguration.apiKey` from `ProcessInfo.processInfo.environment["ZALEX_API_KEY"]` and appended as the `subscription-key` query parameter to request-certificate and request-list endpoints.

## Architecture

The app uses **MVVM** with a **repository** over a thin **API client** and keeps UI, state, and networking clearly separated. SwiftUI views only bind to view models and show alerts/errors; all business logic (validation, submit, load, filter, sort) lives in view models, validators, and the repository. The **CertificateRepository** is the single source of truth for the requests list, subscribes to the API for fetch/submit, and performs local-only updates for F05 (purpose edit when status is "New"). Networking is abstracted behind **APIClientProtocol** (implemented by **URLSessionAPIClient**), and the repository is injected so tests can use **MockAPIClient** and **MockCertificateRepository**. Validation is centralized in **CertificateRequestValidator** (pure, testable); errors are mapped to **APIError** and shown as field-level or global messages.

## Features (MVP)

- **F02** — Request certificate: form (Address to, Purpose ≥50 chars, Issued on future date, Employee ID numeric), inline validation, POST to backend, success confirmation and form reset.
- **F03** — Requests list: Reference No., Address to, Status, Issued on, Purpose snippet; sort by Issued on / Status; filter/search by reference (full match), address (contains words), status (full match).
- **F04** — Request detail: all fields; PDF preview when status is "Done" (sample PDF bundled), otherwise “Certificate is yet to be issued.”; Issued on shown only when status is "Done".
- **F05** — Update: Purpose editable only when status is "New"; save updates local state only (no API); list refreshes from repository.

## Unit tests

- **ZalexTests**: validator rules, view model validation/submit/load/filter/sort/save, repository with **MockAPIClient**.
- Run: Xcode → Product → Test (⌘U), or `xcodebuild test -scheme Zalex -destination 'platform=iOS Simulator,name=iPhone 16,OS=latest' -only-testing:ZalexTests`.

## Project layout

- **App**: `ZalexApp.swift` (entry, injects `CertificateRepository` as environment object).
- **Models**: `CertificateRequest`, `CertificateRequestSubmitBody`, `APIError`.
- **Networking**: `APIClientProtocol`, `URLSessionAPIClient`, `APIEndpoint`, `APIConfiguration`.
- **Repositories**: `CertificateRepository` (protocol + implementation).
- **Validators**: `CertificateRequestValidator`.
- **ViewModels**: `RequestFormViewModel`, `RequestsListViewModel`, `RequestDetailViewModel`.
- **Views**: `RequestFormView`, `RequestsListView`, `RequestDetailView`, `PDFPreviewView`, `ValidatedTextField`, `StatusBadge`.
- **Resources**: `sample_certificate.pdf` (for “Done” status preview).
