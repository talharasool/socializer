import Foundation
import FBSDKLoginKit
import Foundation
import UIKit

class FacebookLoginService : NSObject, AuthService {
    
    
    private enum FBError : LocalizedError{
        
        case Cancelled
        case Declined
        case PermissionNotGranted
        
        var errorDescription: String?{
            switch self {
            case .Cancelled:
                return "Cancelled FB Request"
            case .Declined:
                return "Declined FB Request"
            case .PermissionNotGranted:
                return "PermissionNotGranted by user"
            }
        }
    }
    
    
    private weak var viewController: UIViewController?
    private weak var delegate: AuthServiceDelegate?
    private var backendAuth: ServiceAuthorizer?
    var authType: PreferredAuthMethod = .facebook
    private let permissionParmeters = ["public_profile", "email"]
    private let loginManager = LoginManager()
    
    init(_ viewController: UIViewController?, delegate: AuthServiceDelegate?) {
        self.viewController = viewController
        self.delegate = delegate
        //self.backendAuth = BackendAuthorizer(delegate: delegate)
    }
    
    func authenticate() {
        loginButtonClicked()
    }
    
    func deAuthenticate() {
        // no sign out on apple method.
    }
    
    
}


extension FacebookLoginService {
    
    func loginButtonClicked(){
        let start = CFAbsoluteTimeGetCurrent()
        loginManager.logIn(permissions:permissionParmeters , from: viewController) { result, error in
            
            guard error ==  nil else{
                self.delegate?.authService(self.authType, didFailToAuthorizeWith: FBError.Declined)
                return
            }
            
            guard let result = result , !(result.isCancelled) else{
                self.delegate?.authService(self.authType, didFailToAuthorizeWith: FBError.Cancelled)
                return}
            
            //MARK: Calling the graph Request for data
            GraphRequest.init(graphPath: "me", parameters: ["fields":"id, email, name, picture.width(480).height(480)"]).start { _,fbUser, error in
                guard error == nil else{
                    self.delegate?.authService(self.authType, didFailToAuthorizeWith: FBError.Cancelled)
                    return
                }
                
                if let fbUser = fbUser{
                    let payload = self.getFBPayload(fbUser)
                    self.delegate?.authService(self.authType, didAuthenticate: payload)
                    self.loginManager.logOut()
                }else{
                    self.delegate?.authService(self.authType, didFailToAuthorizeWith: FBError.PermissionNotGranted)
                    self.loginManager.logOut()
                }
                
                //MARK: - Timestamp
                let diff = CFAbsoluteTimeGetCurrent() - start
                print("Took \(diff) seconds")
            }
        }
    }
    
    private func getFBPayload(_ fbUser : Any) -> [String : Any]{
        
        let FBpayload  = fbUser as? [String : Any]
        var profileURL : String  = ""
        let name     = FBpayload?["name"] as? String ?? ""
        let email    = FBpayload?["email"] as? String ?? ""
        let fbUserID = FBpayload?["id"] as? String ?? ""
        if let picture  = FBpayload?["picture"] as? [String : Any],let  data = picture["data"]  as? [String : Any], let url = data["url"] as? String{
            profileURL = url
        }else{profileURL = ""}
        
        let payload : [String : Any] = ["id" : fbUserID , "email" : email, "name" : name,"profileURL" : profileURL]
        return payload
    }
}
