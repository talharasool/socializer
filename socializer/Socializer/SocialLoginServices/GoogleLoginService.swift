
import Foundation
import UIKit
import GoogleSignIn


class GoogleLoginService : NSObject, AuthService {

    
    private weak var viewController: UIViewController?
    private weak var delegate: AuthServiceDelegate?
    private var backendAuth: ServiceAuthorizer?
    var authType: PreferredAuthMethod = .google
    private let permissionParmeters = ["public_profile", "email"]

   private var signInConfig : GIDConfiguration{
       return GIDConfiguration.init(clientID: (self.delegate?.googleConfigurationKey)!)
    }

    
    init(_ viewController: UIViewController?, delegate: AuthServiceDelegate?, key : String) {
        self.viewController = viewController
        self.delegate = delegate
        
        
        //self.backendAuth = BackendAuthorizer(delegate: delegate)
    }
    
    func authenticate() {
        loginButtonClicked()
    }
    
    func deAuthenticate() {
       
    }
    
}


extension GoogleLoginService{
    
    private func loginButtonClicked(){
  
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: viewController!) { [self] user, error in
            
            guard error == nil else { return }
            guard let user = user else { return }

            var profileURL : String! = ""
            let emailAddress = user.profile?.email ?? ""
            let fullName = user.profile?.name ?? ""
            let id  = user.userID ?? ""

            if let avatar = user.profile?.imageURL(withDimension: 320){
                profileURL = String(describing: avatar)
            }
           
            let payload : [String : Any] = ["id" : id , "email" : emailAddress, "name" : fullName,"profileURL" : profileURL ?? ""]
            print("The Payload is here", payload)
            
            delegate?.authService(.google, didAuthenticate: payload)
            GIDSignIn.sharedInstance.signOut()
        }
    }
}
