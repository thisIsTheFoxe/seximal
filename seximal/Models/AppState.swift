//
//  AppState.swift
//  seximal
//
//  Created by Henrik Storch on 24.06.21.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    enum Tab: String, Hashable {
        case convert
        case calc
        case about
    }

    enum ConverterType: String, Hashable {
        case time, length, number
    }

    @Published var selectedTab: Tab = .about
    @Published var activeConverter: ConverterType?

    static let global = AppState()

    private init() { }

    static func url(for tab: Tab, converterType: ConverterType? = nil) -> URL {
        var urlStr = "seximal://app/\(tab.rawValue)"
        if let converterType = converterType {
            urlStr.append("/\(converterType.rawValue)")
        }

        return URL(string: urlStr)!
    }
}
