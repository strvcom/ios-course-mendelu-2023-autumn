//
//  SignInEventHandling.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 20.09.2023.
//

import Foundation

protocol SignInEventHandling: AnyObject {
    func handle(event: SignInView.Event)
}
