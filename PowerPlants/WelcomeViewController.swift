//
//  WelcomeViewController.swift
//  PowerPlants
//
//  Created by Alyssa Schilke on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI
import FirebaseTwitterAuthUI
import FirebasePhoneAuthUI

class WelcomeViewController: UIViewController, FUIAuthDelegate {
    
    var authUI: FUIAuth? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // You need to adopt a FUIAuthDelegate protocol to receive callback
        authUI = FUIAuth.defaultAuthUI()
        
        authUI?.delegate = self
        
        let providers: [FUIAuthProvider] = [
           FUIGoogleAuth(),
           ]
        self.authUI?.providers = providers
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    @IBAction func Login_Button(_ sender: Any) {

        
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        if (user != nil && error == nil){
            performSegue(withIdentifier:"WelcomeToNavCtrl", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

