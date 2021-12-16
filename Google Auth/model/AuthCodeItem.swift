//
//  AuthCodeItem.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 15.09.2021.
//

import Foundation

struct AuthCodeItem: Hashable, Identifiable {
    var id: Int
    var accountName: String
    var authCode: String
}
