//
//  Date+Formatting.swift
//  Zalex
//

import Foundation

extension Date {
    static let apiDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "M/d/yyyy"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f
    }()

    var apiFormatted: String {
        Self.apiDateFormatter.string(from: self)
    }
}
