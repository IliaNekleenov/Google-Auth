//
//  ContentView.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 15.09.2021.
//

import SwiftUI
import CodeScanner

struct ContentView: View {
    @EnvironmentObject var authItemsProvider: AuthCodeItemsProvider
    @State var selectedItemForDeletion: AuthCodeItem? = nil
    @State var repeatingAuthAccount: AuthAccount? = nil
    @State var scanningQr = false
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                TimeProgressView(value: $authItemsProvider.secondsPassed, color: $authItemsProvider.indicatorsColor, maxValue: CODE_LIFE_SECONDS)
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                Button(action: {
                    scanningQr = true
                }, label: {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                            .scaleEffect(CGSize(width: 1.3, height: 1.3))
                        Text("Add account")
                    }
                })
            }
            .padding(.horizontal)
            .background(VisualEffectView(effect: UIBlurEffect(style: .regular)).ignoresSafeArea(.all))
            .zIndex(100)
            VStack {
                ScrollView(showsIndicators: false) {
                    Rectangle()
                        .frame(height: 100)
                        .foregroundColor(.clear)
                    ForEach(authItemsProvider.authCodeItems) { item in
                        AuthCodeItemView(authCodeItem: item, codeColor: $authItemsProvider.indicatorsColor, onDeletion: {
                            selectedItemForDeletion = item
                        })
                        .frame(height: 130)
                        .padding(6)
                    }
                }
                .padding(.horizontal, 15)
            }
            .zIndex(1)
            .onAppear {
                UITableView.appearance().separatorStyle = .none
                authItemsProvider.refreshAuthCodes()
                print("appear")
            }
        }
        .alert(item: $selectedItemForDeletion) { item in
            Alert(
                title: Text("Delete this account?"),
                message: Text("Make sure you have another way to access your account. Deletion can't be undone"),
                primaryButton: .default(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete"), action: {
                    authItemsProvider.delete(id: item.id)
                })
            )
        }
        .actionSheet(item: $repeatingAuthAccount) { authAccount in
            ActionSheet(title: Text("Account " + authAccount.accountName + " already exists"), message: Text("You can create a new account or replace the existing one"), buttons: [
                            .default(Text("Create new account")) {
                                authItemsProvider.addRepeatingAccount(repeatingAccount: authAccount)
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            },
                            .default(Text("Replace existing account")) {
                                authItemsProvider.replaceAccount(account: authAccount)
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                            },
                            .cancel()
            ])
        }
        .sheet(isPresented: $scanningQr) {
            CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
        }
    }
    
    private func handleScan(result: Result<ScanResult,
                            ScanError>) {
        scanningQr = false
        switch result {
        case .success(let res):
            if let newAcc = authItemsProvider.getAuthAccount(from: res.string) {
                if authItemsProvider.authCodeItems.contains(where: {$0.accountName == newAcc.accountName}) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                         self.repeatingAuthAccount = newAcc
                    }
                }
                else {
                    authItemsProvider.add(account: newAcc)
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        default:
            print("error when scanning qr")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .environmentObject(AuthCodeItemsProvider())
    }
}
