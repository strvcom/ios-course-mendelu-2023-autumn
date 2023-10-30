//
//  SignOutView.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2023.
//

import SwiftUI

struct SignOutView: View {
    // navigation
    enum Event {
        case signOut
    }

    @StateObject var store: SignOutStore
    weak var coordinator: SignOutEventHandling?

    var body: some View {
        VStack {
            // if you want, you can change it to store.user and show properties from BE
            // don't forget to unwrap option property User
            Text("ID: \(store.user?.id ?? 0)")
            Text("title: \(store.user?.title ?? "Nothing")")
            Button("Sign Out") {
                coordinator?.handle(event: .signOut)
            }
            .padding()
            .clipShape(Capsule())
        }
    }
}

struct SignOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignOutView(store: SignOutStore(validationManager: ValidationManager(), apiManager: APIManager()))
    }
}
