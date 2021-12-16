//
//  AuthAccount.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 15.09.2021.
//

import Foundation

struct AuthAccount: Codable, Identifiable {
    var id: Int
    var accountName: String
    var secret: String
}
