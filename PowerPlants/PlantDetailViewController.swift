//
//  PlantDetailViewController.swift
//  PowerPlants
//
//  Created by Rebecca Martino on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import Bean_iOS_OSX_SDK
import WMGaugeView

class PlantDetailViewController: UIViewController, PPABeanSyncDelegate {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var gaugeView: WMGaugeView!
    
    func didConnectToBean(bean: PTDBean) {
        
    }
    
    func didCollectMeasurement(bean: PTDBean, temp: String, soil: String) {
        
      
        let celsius = Float(temp)!
        let f: Int =  Int((celsius*(9/5)+32).rounded())
        
        let scaledMoisture = convertToRange(number: Double(soil)!)
        
        tempLabel.text = "\(f)"
        gaugeView.setValue(Float(f), animated: true, duration: 0.9)
        
        

   }
    
    func didDisconnectFromBean(bean: PTDBean) {
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Hi")
        var powerbeanID = "E914B3D8-639D-06F4-F782-128EF4F48F01"
        
        PPABeanSyncUtility.shared.delegate = self
        PPABeanSyncUtility.shared.startScanning(uuid: powerbeanID)
        
        gaugeView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat
        
        gaugeView.maxValue = 100
        gaugeView.scaleDivisions = 10;
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertToRange(number: Double) -> Double {
        return (number) / (300) * 100
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
