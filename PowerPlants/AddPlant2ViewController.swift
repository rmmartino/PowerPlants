//
//  AddPlant2ViewController.swift
//  PowerPlants
//
//  Created by Alyssa Schilke on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
class AddPlant2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    public var plantName: String?
    public var plantType : String?
    var snapshot: [QueryDocumentSnapshot] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        
        let plantTypeRefs = db.collection("Plant_Types")
        
        plantTypeRefs.addSnapshotListener(options: nil) { (snp, err) in
            if let documents = snp?.documents {
                self.snapshot = documents
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
    
    }

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

        

        
        
    
    
        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return snapshot.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "KindTableViewCell", for: indexPath)  as! KindTableViewCell
            let plantKinds = snapshot[indexPath.row]
            let plantTypeName = plantKinds.get("name") as! String
            cell.plantKindLabel.text = "\(plantTypeName)"
            plantType = plantTypeName
            
            
                     return cell

    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //send plantType to  dB
        var snapshot: [QueryDocumentSnapshot] = []
        let db = Firestore.firestore()
        let newPlantRef = db.collection("users/5BI75Xa099RRvnkekLoyIJO2xWv2/plants")
        var ref: DocumentReference? = nil
        ref = db.collection("users/5BI75Xa099RRvnkekLoyIJO2xWv2/plants").addDocument(data: [
            "name": self.plantName,
            "plant_type": self.plantType
            ])
    }
}
