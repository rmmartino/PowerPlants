//
//  PlantTableViewController.swift
//  PowerPlants
//
//  Created by Alyssa Schilke on 1/26/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class PlantTableViewController: UITableViewController {

    var snapshot: [QueryDocumentSnapshot] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let db = Firestore.firestore()
        
        let plantsRef = db.collection("users/5BI75Xa099RRvnkekLoyIJO2xWv2/plants")
        
        plantsRef.addSnapshotListener(options: nil) { (snp, err) in
            if let documents = snp?.documents {
                self.snapshot = documents
                self.tableView.reloadData()
            }
        }
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return snapshot.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlantTableViewCell", for: indexPath)  as! PlantTableViewCell
        
        let plant = snapshot[indexPath.row]
        let plantName = plant.get("name") as! String
        cell.plantNameLabel.text = "\(plantName)"
        
        let plantType = plant.get("plant_type") as! String
        cell.plantTypeLabel.text = "\(plantType)"
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("images")
        let fileName = "delray-plants-house-plants-6zz-64_1000.jpg"
        let spaceRef = imagesRef.child(fileName)
        let path = spaceRef.fullPath;
        let name = spaceRef.name;
        let plantPicture = plant.get("image_reference")
        let gsReference = storage.reference(forURL: "gs://powerplants-c46e2.appspot.com/plantPicture")
        // Create a reference to the file you want to download
        
        let islandRef = storageRef.child("plants/\(plant.documentID).jpg")
        
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                cell.happyPlantImage.image = image
            }
        }
     
        
        //var spaceRef = storageRef.child("images/space.jpg")
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
