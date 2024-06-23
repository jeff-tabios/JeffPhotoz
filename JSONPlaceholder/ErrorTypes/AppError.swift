//
//  AppError.swift
//  JSONPlaceholder
//
//  Created by Jeffrey Tabios on 6/23/24.
//

import Foundation

struct AppError: Identifiable {
    let id = UUID()
    let message: String
}
