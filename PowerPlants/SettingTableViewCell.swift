//
//  SettingTableViewCell.swift
//  PowerPlants
//
//  Created by Michael Latman on 1/28/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import Bohr
import FirebaseAuth

class SettingTableViewCell: BOTableViewController {
    override func setup() {
        
        var email = Auth.auth().currentUser?.email
        if(email != nil){
        self.addSection(BOTableViewSection.init(headerTitle: "Account", handler: { (section) in
            section?.addCell(BOTextTableViewCell.init(title: "\(email!)", key: "dwd", handler: { (dwd) in
                
            }))
            
            let logoutCell = BOButtonTableViewCell.init(title: "Logout", key: "signoutButton", handler: { (btn) in
               
            })
            
            logoutCell?.actionBlock = {
                
                try! Auth.auth().signOut()
                self.present(UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController()!, animated: true, completion: {
                    
                })
            }
            section?.addCell(logoutCell)
        }))
        }
    }
   
    


}
