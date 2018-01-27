//
//  AddPlant1ViewController.swift
//  PowerPlants
//
//  Created by Alyssa Schilke on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
class AddPlant1ViewController: UIViewController {
    var plantName: String? = nil
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plantName = String()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Actions
    
    @IBAction func PressNext(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "StepTwo"
        {
            let vc = segue.destination as! AddPlant2ViewController
            self.plantName = nameField.text!
            vc.plantName = self.plantName!
        }
    }
    

}
