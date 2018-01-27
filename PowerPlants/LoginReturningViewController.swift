//
//  LoginReturningViewController.swift
//  PowerPlants
//
//  Created by Alyssa Schilke on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit

class LoginReturningViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordPrompt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func press_Next(_ sender: UIButton) {
        var passwordEntered = passwordField.text
        while(passwordField.text != "Hi") {
            passwordPrompt.adjustsFontSizeToFitWidth = true;
            passwordPrompt.minimumScaleFactor = 0.1
            passwordPrompt.text = "Password incorrect"
            
            passwordEntered = passwordField.text
             }
        self.performSegue(withIdentifier: "segueFromLoginToPlantList", sender: self)
       
        /*
         if username is in database
         and password matches username's password
          move to next scene
         */
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
