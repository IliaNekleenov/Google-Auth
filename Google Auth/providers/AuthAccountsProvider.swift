//
//  AuthAccountsProvider.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 15.09.2021.
//

import Foundation

fileprivate let accountsFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("accounts.json")

class AuthAccountsProvider {
    var accounts: [AuthAccount] = [] {
        didSet {
            self.saveAccountsToFile()
        }
    }
    
    init() {
        self.accounts = self.getAccountsFromFile()
    }
    
    private func getAccountsFromFile() -> [AuthAccount] {
        print("getting accounts from file")
        do {
            let data = try Data(contentsOf: accountsFileUrl)
            let parsed = try JSONDecoder().decode([AuthAccount].self, from: data)
            return parsed
        } catch {
            print("could not get accounts from file", error.localizedDescription)
        }
        return []
    }
    
    private func saveAccountsToFile() {
        print("saving accounts to file")
        do {
            let encoded = try JSONEncoder().encode(accounts)
            try encoded.write(to: accountsFileUrl)
        } catch {
            print("could not save accounts to file")
        }
    }
}
