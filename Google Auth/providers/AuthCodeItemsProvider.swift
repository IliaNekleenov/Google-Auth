//
//  AuthCodeItemsProvider.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 15.09.2021.
//

import Foundation
import SwiftUI

class AuthCodeItemsProvider: ObservableObject {
    
    @Published public private(set) var authCodeItems: [AuthCodeItem] = []
    @Published var secondsPassed: Int
    @Published var indicatorsColor: Color
    
    let authAccountsProvider = AuthAccountsProvider()
    let authCodeGenerator = AuthCodeGenerator()
    let indicatorsColorProvider: IndicatorsColorProvider
    
    init() {
        self.indicatorsColorProvider = IndicatorsColorProvider(startColor: .blue.opacity(0.65), endColor: .red.opacity(0.65), maxSeconds: CODE_LIFE_SECONDS) {_,_ in}
        self.secondsPassed = indicatorsColorProvider.secondsPassed
        self.indicatorsColor = indicatorsColorProvider.indicatorsColor
        self.indicatorsColorProvider.onNewSecond = { s, c in
            self.secondsPassed = s
            self.indicatorsColor = c
            if s == 0 {
                self.refreshAuthCodes()
            }
        }
        self.refreshAuthCodes()
    }
    
    public func add(account: AuthAccount) {
        self.authAccountsProvider.accounts.insert(account, at: 0)
        self.authCodeItems.insert(AuthCodeItem(id: account.id, accountName: account.accountName, authCode: authCodeGenerator.generateCode(for: account.secret)), at: 0)
    }
    
    public func delete(id: Int) {
        self.authCodeItems.removeAll(where: {$0.id == id})
        self.authAccountsProvider.accounts.removeAll(where: {$0.id == id})
    }
    
    public func refreshAuthCodes() {
        self.authCodeItems = authAccountsProvider.accounts.map { acc in
            AuthCodeItem(id: acc.id, accountName: acc.accountName, authCode: authCodeGenerator.generateCode(for: acc.secret))
        }
    }
    
    public func createAuthAccount(accountName: String, secret: String) -> AuthAccount {
        return AuthAccount(id: Int(Date.timeIntervalSinceReferenceDate), accountName: accountName, secret: secret)
    }
    
    public func replaceAccount(account: AuthAccount) {
        guard let toReplace = self.authAccountsProvider.accounts.firstIndex(where: {$0.accountName == account.accountName}) else {return}
        self.authAccountsProvider.accounts[toReplace].secret = account.secret
        self.authCodeItems[toReplace].authCode = authCodeGenerator.generateCode(for: account.secret)
    }
    
    public func addRepeatingAccount(repeatingAccount: AuthAccount) {
        let repeatingAccounts = self.authCodeItems.filter{$0.accountName.starts(with: repeatingAccount.accountName)}
        let numbers = repeatingAccounts.map{item in Int(item.accountName.replacingOccurrences(of: repeatingAccount.accountName + "-", with: "")) ?? 1}
        let maxNumber = numbers.max() ?? 1
        let account = AuthAccount(id: Int(Date.timeIntervalSinceReferenceDate), accountName: repeatingAccount.accountName + "-" + String(maxNumber + 1), secret: repeatingAccount.secret)
        self.add(account: account)
    }
    
    public func getAuthAccount(from urlString: String) -> AuthAccount? {
        guard let url = URLComponents(string: urlString), let secret = url.queryItems?.first(where: {$0.name == "secret"})?.value else {return nil}
        let path = url.path
        if !path.starts(with: "/Google:") || !path.hasSuffix("@gmail.com") {
            return nil
        }
        let accName = path.replacingOccurrences(of: "/Google:", with: "").replacingOccurrences(of: "@gmail.com", with: "")
        return AuthAccount(id: Int(Date.timeIntervalSinceReferenceDate), accountName: accName, secret: secret)
    }
    
}
