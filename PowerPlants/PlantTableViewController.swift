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
import BulletinBoard
import Bean_iOS_OSX_SDK

class PlantTableViewController: UITableViewController, PTDBeanManagerDelegate, PTDBeanDelegate {
    var linkAlertUp = false
    var beanyManager: PTDBeanManager?
    var linkedBean: PTDBean?
    
    lazy var bulletinManager: BulletinManager = {
 
        let connectPage = PageBulletinItem(title: "Found PowerSeed")
        connectPage.image = UIImage.init(named: "beanimg")
        connectPage.descriptionText = "Let's link your PowerSeed Sensor"
        connectPage.actionButtonTitle = "Link Now"
        connectPage.alternativeButtonTitle = "Not now"
        connectPage.actionHandler = { (item: PageBulletinItem) in
            print("Action button tapped")
            self.linkAlertUp = false
            var error: NSError?
            
            item.manager?.dismissBulletin(animated: true)
            self.beanyManager?.stopScanning(forBeans_error: &error)
            self.openPlantForm()
        }
        
        connectPage.alternativeHandler = { (item: PageBulletinItem) in
            print("Close")
            self.linkAlertUp = false
            item.manager?.dismissBulletin(animated:true)
        }
        
      
        connectPage.isDismissable = false
        
        let rootItem: BulletinItem = connectPage
        
        
        return BulletinManager(rootItem: rootItem)
        
    }()
    
    
    var snapshot: [QueryDocumentSnapshot] = []

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        beanyManager = PTDBeanManager()
        
         beanyManager?.delegate = self
       
        
        

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
    
    func openPlantForm(){
        let pform = AddPlantFormController.init()
        pform.seedUUID = linkedBean?.identifier.uuidString
        let navigationController = UINavigationController(rootViewController: pform)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    var knownSensors: [QueryDocumentSnapshot]? = nil
    
    override func viewDidAppear(_ animated: Bool) {
        let db = Firestore.firestore()
        let sensorsRef = db.collection("users/5BI75Xa099RRvnkekLoyIJO2xWv2/sensors")
        sensorsRef.getDocuments { (docs, err) in
            if let sensors = docs {
                self.knownSensors = sensors.documents
                self.attemptAdd()
            }
        }
  
    }
    
    func attemptAdd(){
        doScan {
            self.linkAlertUp = true
            self.bulletinManager.prepare()
            self.bulletinManager.presentBulletin(above: self)
        }
    }
    
    var doneCallback: (() -> Void)? = nil
    func doScan(done: @escaping () -> Void) {
        // function body goes here
        doneCallback = done
        var error: NSError?
        
        self.beanyManager?.startScanning(forBeans_error: &error)
        if(error != nil){
            print("ERR")
        }
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!) {
        print("Found Bean \(bean.identifier.uuidString)")
        
        if knownSensors != nil {
            for sen in knownSensors! {
                if(sen.get("uuid") as! String == bean.identifier.uuidString){
                    return;
                }
            }
        }
        
        var error: NSError?
        beanManager.connect(to: bean, withOptions: [:], error: &error)
        var stoperror: NSError?
        linkedBean = bean
        self.beanyManager?.stopScanning(forBeans_error: &stoperror)
        self.doneCallback?()
    }
    
    func beanManager(_ beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: Error!) {
        if(linkAlertUp){
            linkAlertUp = false
            bulletinManager.dismissBulletin(animated: true)
        }
        attemptAdd()
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
        let location = plant.get("location") as! String
        cell.plantTypeLabel.text = "\(plantType) - \(location)"
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
