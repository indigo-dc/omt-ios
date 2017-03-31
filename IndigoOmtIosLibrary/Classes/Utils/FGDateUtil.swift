//
//  FGDateUtil.swift
//  IndigoOmtIosLibrary
//
//  Created by Sebastian Mamczak on 23.01.2017.
//
//

import Foundation

/// Simple Date util.
open class FGDateUtil {

    /// Default locale.
    static let DefaultLocale: Locale = Locale(identifier: "en_US_POSIX")

    /// Supported dates formats.
    static let Formats = [
        "EEE MMM dd HH:mm:ss ZZZ yyyy",
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
        "yyyy-MM-dd'T'HH:mm:ssZ",
        "yyyy-MM-dd HH:mm:ss Z",
        "yyyy-MM-dd HH:mm:ss",
        "yyyy-MM-dd HH:mm",
        "yyyy-MM-dd"
    ]

    /// Parses string to date.
    static public func parseDate(_ input: String?) -> Date? {
        if let str = input {
            let formatter = DateFormatter()
            formatter.locale = FGDateUtil.DefaultLocale
            for format in FGDateUtil.Formats {
                formatter.dateFormat = format
                if let date = formatter.date(from: str) {
                    return date
                }
            }
        }
        return nil
    }

    static public func format(_ format: String, date: Date?) -> String? {
        if let date = date {
            let formatter = DateFormatter()
            formatter.locale = FGDateUtil.DefaultLocale
            formatter.dateFormat = format
            return formatter.string(from: date)
        }
        return nil
    }

}
