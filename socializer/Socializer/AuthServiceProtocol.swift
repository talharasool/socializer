//
//  AuthServiceProtocol.swift
//  socialService
//
//  Created by mac on 29/12/2021.
//

import Foundation
import AuthenticationServices
import UIKit


protocol AuthService {
    var  authType: PreferredAuthMethod { get }
//    var googleConfigurationKey : String? {get}
    func authenticate()
    func deAuthenticate()
}

//extension AuthService{
//
//    var googleConfigurationKey: String? {return nil}
//}

protocol AuthServiceDelegate: AnyObject {
    
    var userAuthenticator: UserAuthenticator! { get }
    var googleConfigurationKey: String! {get}
    /// Fired when user is authorised and confirmed via backend, returning user-info.
    /// - Parameters:
    ///   - authService: service type.
    ///   - user: user info object.
    func authService(_ authService: PreferredAuthMethod, didAuthenticate user: Any)
    
    /// Reporting auth failure, with service and error.
    /// - Parameters:
    ///   - authService: service type.
    ///   - error: errors.
    func authService(_ authService: PreferredAuthMethod, didFailToAuthorizeWith error: Error)
}


extension AuthServiceDelegate{
    var googleConfigurationKey: String! {return nil}
}
