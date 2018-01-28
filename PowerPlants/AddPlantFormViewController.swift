//
//  AddPlantFormViewController.swift
//  PowerPlants
//
//  Created by Michael Latman on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import Foundation

import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import Eureka
import ImageRow

class AddPlantFormController: FormViewController {
    var seedUUID: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Add Plant"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: .plain, target: self, action: #selector(dismissView))
        form +++ Section("Plant Info")
       
            <<< TextRow("plantName"){ row in
                row.title = "Name"
                row.placeholder = "Green Fern"
            }
            <<< TextRow("Location"){ row in
                row.title = "Location"
                row.placeholder = "Living Room Porch"
                row.hidden = Condition.function(["plantName"], { form in
                    let v = (form.rowBy(tag: "plantName") as? TextRow)!.value
                    return (v == nil) || (v!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)
                })
            }
            <<< PushRow<QueryDocumentSnapshot>("PlantType") {
                $0.title = "Plant Type"
                $0.options = []
                $0.value = nil
                $0.selectorTitle = "Choose A Plant Type"
                $0.displayValueFor  = {
                    if let t = $0 {
                        return t.get("name") as? String
                    }
                    return nil
                }
                $0.hidden =  Condition.function(["Location"], { form in
                    let v = (form.rowBy(tag: "Location") as? TextRow)!.value
                    return (v == nil) || (v!.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty)
                })
                }.onPresent { from, to in
                    to.dismissOnSelection = false
                    to.dismissOnChange = false
                    to.selectableRowCellUpdate = { cell, row in
                        cell.textLabel?.text = row.selectableValue!.get("name") as? String  // customization
                        cell.detailTextLabel?.text = row.selectableValue!.get("description") as? String
                    }
            }
            +++ Section("")
            
            <<< ImageRow("Photo") {
                $0.title = "Take Picture (Optional)"
                $0.hidden =  Condition.function(["PlantType"], { form in
                    let v = (form.rowBy(tag: "PlantType") as? PushRow<QueryDocumentSnapshot>)!.value
                    return (v == nil)
                })
            }
            <<< ButtonRow(){
                $0.title = "Save"
                $0.onCellSelection({ (cellof, row) in
                    print("\(Auth.auth().currentUser!.uid)")
                    let db = Firestore.firestore()
              
                 
                    let ref = db.collection("users/\(Auth.auth().currentUser!.uid)/plants").addDocument(data: [
                        "name": (self.form.rowBy(tag: "plantName") as! TextRow).value as! String,
                        "plant_type": (self.form.rowBy(tag: "PlantType") as! PushRow<QueryDocumentSnapshot>).value!.get("name") as! String,
                        "location": (self.form.rowBy(tag: "Location") as! TextRow).value! as! String,
                        "type_ref":(self.form.rowBy(tag: "PlantType") as! PushRow<QueryDocumentSnapshot>).value?.reference
                        
                        ])
                    
                    
                    let newSensor = db.collection("users/\(Auth.auth().currentUser!.uid)/sensors")
                    newSensor.addDocument(data: [
                        "uuid": self.seedUUID
                        ])
                    
                    
                    let storage = Storage.storage()
                    let sref = storage.reference(withPath: "plants/\(ref.documentID).jpg")
                    
                    if((self.form.rowBy(tag: "Photo") as! ImageRow).value != nil){
                        let upload = sref.putData(UIImageJPEGRepresentation((self.form.rowBy(tag: "Photo") as! ImageRow).value as! UIImage, 0.3)!, metadata: nil) { (metadata, error) in
                            guard let metadata = metadata else {
                                // Uh-oh, an error occurred!
                                return
                            }
                            // Metadata contains file metadata such as size, content-type, and download URL.
                            self.addAndDone()
                        }
                    }
                    else{
                        self.addAndDone()
                    }
                 
             
                })
                $0.hidden =  Condition.function(["PlantType"], { form in
                    let v = (form.rowBy(tag: "PlantType") as? PushRow<QueryDocumentSnapshot>)!.value
                    return (v == nil)
                })
        }
        
        
        
        let db = Firestore.firestore()
        
        let plantTypeRefs = db.collection("Plant_Types")
        
        plantTypeRefs.addSnapshotListener(options: nil) { (snp, err) in
            if let documents = snp?.documents {
                (self.form.rowBy(tag: "PlantType") as! PushRow<QueryDocumentSnapshot>).options = documents
            }
        }
        
        
        
        
            
        // Enables the navigation accessory and stops navigation when a disabled row is encountered
        navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
        // Enables smooth scrolling on navigation to off-screen rows
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
    }
    
    func addAndDone(){
        
    
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissView(sender: Any?){
        self.dismiss(animated: true, completion: nil)
    }
}
