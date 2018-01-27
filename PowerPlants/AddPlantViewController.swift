//
//  AddPlantViewController.swift
//  PowerPlants
//
//  Created by Alyssa Schilke on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class AddPlantViewController: UIViewController {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameEntryField: UITextField!
    
    @IBOutlet var NextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func saveTextToVar(sender: UIButton) {
        let plantName = nameEntryField.text
    }
    //to datbase function
    let db = Firestore.firestore()
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
