//
//  ViewController.swift
//  socializer
//
//  Created by mac on 04/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    var userAuthenticator: UserAuthenticator!
    @IBOutlet weak var appleButton : UIButton!
    @IBOutlet weak var googleButton : UIButton!
    @IBOutlet weak var facebookutton : UIButton!
    

    var googleConfigurationKey: String! = "30208098798-8rojc62he4ak47vabik3sul15llav2ci.apps.googleusercontent.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userAuthenticator = UserAuthenticator.init(self)
        
        appleButton.addTarget(self, action: #selector(didTapOnApple(_:)), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(didTapOnGoogle(_:)), for: .touchUpInside)
        facebookutton.addTarget(self, action: #selector(didTapOnFacebook(_:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }

    
    @objc func didTapOnApple(_ sender : UIButton){
        userAuthenticator.authenticate(.apple)
    }
    
    @objc func didTapOnFacebook(_ sender : UIButton){
        userAuthenticator.authenticate(.facebook)
    }
    
    @objc func didTapOnGoogle(_ sender : UIButton){
        userAuthenticator.authenticate(.google)
    }

}

extension ViewController : AuthServiceDelegate{
    
    func authService(_ authService: PreferredAuthMethod, didAuthenticate user: Any) {
        print("Payload is here",user)
    }
    
    func authService(_ authService: PreferredAuthMethod, didFailToAuthorizeWith error: Error) {
        print("Error is here")
    }
}

