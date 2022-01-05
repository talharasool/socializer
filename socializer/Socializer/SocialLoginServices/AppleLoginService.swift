import Foundation
import UIKit
import AuthenticationServices

protocol ServiceAuthorizer {
    func authorize(_ results: ASAuthorizationAppleIDCredential)
}

class AppleAuthService: NSObject, AuthService {
    
    private weak var viewController: UIViewController?
    private weak var delegate: AuthServiceDelegate?
    private var backendAuth: ServiceAuthorizer?
    var authType: PreferredAuthMethod = .apple
    
    
    init(_ viewController: UIViewController?, delegate: AuthServiceDelegate?) {
        self.viewController = viewController
        self.delegate = delegate
        
        //self.backendAuth = BackendAuthorizer(delegate: delegate)
    }

    func authenticate() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
          request.requestedScopes = [.fullName, .email]
          
          let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
          authorizationController.delegate = self
          authorizationController.presentationContextProvider = self
          authorizationController.performRequests()
    }

    func deAuthenticate() {
        // no sign out on apple method.
    }
}


@available(iOS 13.0, *)
extension AppleAuthService: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let userIdentifier = appleIDCredential.user
            let email = appleIDCredential.email ?? ""
            let name  = (appleIDCredential.fullName?.givenName ?? "") + (appleIDCredential.fullName?.familyName ?? "")
            
            
            let payload : [String : Any] = ["id" : userIdentifier , "email" : email, "name" : name]
            
            print("Apple Payload")
            print(payload)
            delegate?.authService(authType, didAuthenticate: payload)
        }
    }
    
    
    

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //AuthenticationError.appleError(code: error.errorCode)
        
        print("Error in Authenticating",error)
        switch error {
        case let error as ASAuthorizationError:
            delegate?.authService(authType, didFailToAuthorizeWith: error)
        default:
            delegate?.authService(authType, didFailToAuthorizeWith: error)
        }
    }
}

@available(iOS 13.0, *)
extension AppleAuthService: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = viewController?.view.window else {
            fatalError("couldn't find window")
        }
        return window
    }
}
