//
//  UserAuthenticator.swift
//  socialService
//
//  Created by mac on 29/12/2021.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
typealias AuthenticationViewSource = UIViewController & AuthServiceDelegate

@available(iOS 13.0, *)
class UserAuthenticator {
    
    private weak var source: AuthenticationViewSource?
    private var service: AuthService?

    init(_ viewController: AuthenticationViewSource) {
        self.source = viewController
    }

    func authenticate(_ type: PreferredAuthMethod) {
        guard let source = source else { return }
        service = type.getService(source: source, delegate: source)
        service?.authenticate()
    }

    func deAuthenticate(type: PreferredAuthMethod) {
        guard let source = source else { return }
        service = type.getService(source: source, delegate: source)
        service?.deAuthenticate()
    }
}
