//
//  SignInView.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2023.
//

import SwiftUI

struct SignInView: View {
    // navigation
    enum Event {
        case goToSignOut
    }
    
    @StateObject var store: SignInStore
    weak var coordinator: SignInEventHandling?

    var body: some View {
        VStack {
            Spacer()
            TextField("Email", text: $store.emailText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .accessibilityIdentifier("signInTextField")
            
            SecureField("Password", text: $store.passwordText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .accessibilityIdentifier("signInSecureField")
            
            Spacer()
            Button("Sign In") {
                coordinator?.handle(event: .goToSignOut)
            }
            .disabled(store.buttonDisabled)
            .padding()
            .background(store.buttonDisabled ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .accessibilityIdentifier("signInButton")
            Spacer()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(store: SignInStore(validationManager: ValidationManager()))
    }
}
