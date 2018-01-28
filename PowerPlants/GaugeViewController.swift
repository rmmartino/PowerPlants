//
//  GaugeViewController.swift
//  PowerPlants
//
//  Created by Rebecca Martino on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import Bean_iOS_OSX_SDK
import WMGaugeView

class GaugeViewController: UIViewController, UIPageViewControllerDelegate {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var gaugeView: WMGaugeView!
    
    @IBOutlet weak var gaugeLabel: UILabel!
    
    var units = ""

    var gaugeLabelTemp = ""
    private var gaugeValRel: Float = 0.0;
    var gaugeValueTemp: Float {
        set(val) {
            gaugeValRel = val
            if(gaugeView != nil) {
                gaugeView!.setValue(gaugeValRel, animated: true, duration: 0.9)
                
                valueLabel.text = "\(Int(gaugeValRel))\(units)"
            }
        }
        get {
            return gaugeValRel
        }
    }
    
    var rangeValues = [33,66,100]
    
    var ranges: [Int] {
        get {
            return rangeValues
        }
        set(val) {
            rangeValues = val
            if(self.gaugeView != nil){
                self.gaugeView.rangeValues = rangeValues
            }
        }
    }
    
    var rangeColors = [UIColor(red: 232.0 / 255.0, green: 111 / 255.0, blue: 33 / 255.0, alpha: 1.0), UIColor(red: 39 / 255.0, green: 185 / 255.0, blue: 70 / 255.0, alpha: 1.0), UIColor(red: 231 / 255.0, green: 32 / 255.0, blue: 43 / 255.0, alpha: 1.0)]
    
    var rangeLabels = ["Needs water", "Optimal", "Over watered"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gaugeView!.setValue(gaugeValRel, animated: true, duration: 0.9)
        gaugeLabel.text = gaugeLabelTemp
        valueLabel.text = "--"
        
        gaugeView.showRangeLabels = true
        gaugeView.rangeValues = rangeValues
        gaugeView.rangeColors = rangeColors
        gaugeView.rangeLabelsFontColor = UIColor.white
        gaugeView.rangeLabelsWidth = 0.04
        gaugeView.rangeLabelsFont = UIFont.init(name: "AvenirNext", size: 0.04)
        gaugeView.rangeValues = rangeValues
        
        gaugeView.rangeLabels = rangeLabels
       
        var powerbeanID = "E914B3D8-639D-06F4-F782-128EF4F48F01"
           /*PPABeanSyncUtility.shared.delegate = self as! PPABeanSyncDelegate
   */
        gaugeView.innerBackgroundStyle = WMGaugeViewInnerBackgroundStyleFlat
        
        gaugeView.maxValue = 100
        gaugeView.scaleDivisions = 10;
       
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

}
