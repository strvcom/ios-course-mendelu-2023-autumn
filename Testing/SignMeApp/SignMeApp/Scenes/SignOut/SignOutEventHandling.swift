//
//  SignOutEventHandling.swift
//  SignMeApp
//
//  Created by Martin Vidovic on 30.10.2023.
//

import Foundation

protocol SignOutEventHandling: AnyObject {
    func handle(event: SignOutView.Event)
}
