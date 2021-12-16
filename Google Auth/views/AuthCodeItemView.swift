//
//  AuthCodeItemView.swift
//  Google Auth
//
//  Created by NEKLEENOV Ilya on 16.09.2021.
//

import SwiftUI

struct AuthCodeItemView: View {
    let authCodeItem: AuthCodeItem
    @Binding var codeColor: Color
    let onDeletion: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State var copiedPopupOpacity = 0.0
    
    var body: some View {
        GeometryReader { g in
            ZStack(alignment: .topTrailing) {
                
                Button(action: {
                    self.onDeletion()
                }, label: {
                    Image(systemName: "trash")
                        .foregroundColor(.gray.opacity(0.7))
                })
                .zIndex(100)
                .padding()
                
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        ZStack {
                            Text(authCodeItem.accountName)
                                .padding(.horizontal)
                                .font(.title.weight(.semibold))
                                .opacity(1 - copiedPopupOpacity)
                            Text("copied")
                                .padding(7)
                                .font(.title)
                                .opacity(copiedPopupOpacity)
                        }
                        Text(formatAuthCode(code: authCodeItem.authCode))
                            .padding(.horizontal)
                            .font(Font.system(size: 45, weight: .regular, design: .default))
                            .foregroundColor(codeColor)
                            .onLongPressGesture {
                                UIPasteboard.general.string = authCodeItem.authCode
                                UINotificationFeedbackGenerator().notificationOccurred(.success)
                                withAnimation {
                                    self.copiedPopupOpacity = 1
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    withAnimation {
                                        self.copiedPopupOpacity = 0
                                    }
                                }
                            }
                    }
                    Spacer()
                }
                .frame(width: g.size.width, height: g.size.height, alignment: .center)
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .shadow(radius: 2.5)
                        .foregroundColor(
                            colorScheme == .dark ?
                                Color(red:  0.1, green: 0.1, blue: 0.1) :
                                Color(red: 0.9, green: 0.9, blue: 0.9)
                        )
                )
                .zIndex(1)
            }
        }
    }
    
    private func formatAuthCode(code: String) -> String {
        return code.prefix(3) + " " + code.suffix(3)
    }
}

struct AuthCodeItemView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { g in
            AuthCodeItemView(authCodeItem: AuthCodeItem(id: 1, accountName: "neiluhha", authCode: "442020"), codeColor: Binding.constant(.orange), onDeletion: {})
                .frame(width: g.size.width, height: g.size.height / 5, alignment: .center)
        }
        .preferredColorScheme(.light)
    }
}
