//
//  preferredLoginMethod.swift
//  socialService
//
//  Created by mac on 29/12/2021.
//

import Foundation
import UIKit


enum PreferredAuthMethod{
//  case phone(number: String)
//  case email(email: String, password: String)
  case google
  case facebook
  case apple
    
}

extension PreferredAuthMethod {
    func getService(source: UIViewController?, delegate: AuthServiceDelegate?) -> AuthService {
        switch self {
        case .apple:
            let service  = AppleAuthService(source, delegate: delegate)
            print("The service is here", service)
            return service
        case .facebook:
            let service = FacebookLoginService(source, delegate: delegate)
            return service
            
        case .google:
            let service = GoogleLoginService(source, delegate: delegate, key: (delegate?.googleConfigurationKey!)!)
            return service
        }
    }
}
