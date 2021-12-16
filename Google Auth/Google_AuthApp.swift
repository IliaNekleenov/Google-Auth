//
//  Google_AuthApp.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 15.09.2021.
//

import SwiftUI

@main
struct Google_AuthApp: App {
    @ObservedObject var authCodeItemsProvider = AuthCodeItemsProvider()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authCodeItemsProvider)
        }
    }
}
