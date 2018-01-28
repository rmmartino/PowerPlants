//
//  SensorPageViewController.swift
//  PowerPlants
//
//  Created by Rebecca Martino on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import UIKit
import Bean_iOS_OSX_SDK
import WMGaugeView
import FirebaseFirestore

class SensorPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, PPABeanSyncDelegate {
    func didConnectToBean(bean: PTDBean) {
        
    }
    
    var type_ref: DocumentReference? = nil
    var pageControl = UIPageControl()
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var gaugeView: WMGaugeView!
    
    func didCollectMeasurement(bean: PTDBean, temp: String, soil: String) {
        
        let celsius = Float(temp)!
        let f: Int =  Int((celsius*(9/5)+32).rounded())
        
        tempVC?.gaugeValueTemp = Float(f)
        
        var scaledMoisture = (convertToRange(number: Double(soil)!)).rounded()
        
        if scaledMoisture > 100{
            scaledMoisture = 100
        }
        
        
        
        soilVC?.gaugeValueTemp = Float(scaledMoisture)
 
       
        //tempLabel.text = "\(f)"
        
    }
    
    func didDisconnectFromBean(bean: PTDBean) {
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
     
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        self.delegate = self
        configurePageControl()
        
        var powerbeanID = "E8532FA8-BDCC-1100-6762-AFF438E42373"
        
        PPABeanSyncUtility.shared.delegate = self
        PPABeanSyncUtility.shared.startScanning(uuid: powerbeanID)
    
       
        
        // This sets up the first view that will show up on our page control
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        let plantTypeRef = self.type_ref
        

        
        plantTypeRef?.getDocument { (doc, err) in
            if let doc = doc {
                let moistureMax = (doc.get("moistureMax") as! NSNumber).intValue
                let moistureMin = (doc.get("moistureMin") as! NSNumber).intValue
                
                let tempMax = (doc.get("temperatureMax") as! NSNumber).intValue
                let tempMin = (doc.get("temperatureMin") as! NSNumber).intValue
                self.soilVC?.ranges = [moistureMin,moistureMax,100]
                
                self.tempVC?.ranges = [tempMin,tempMax,100]
            }
        }
    }
    

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            // return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func newVc(viewController: String) -> UIViewController{
        return UIStoryboard(name: "PlantDetailStoryboard", bundle: nil).instantiateViewController(withIdentifier: viewController)
    }
    
    var tempVC: GaugeViewController? = nil
    var soilVC: GaugeViewController? = nil
    lazy var orderedViewControllers: [UIViewController] = {
        tempVC = self.newVc(viewController: "Gauge") as! GaugeViewController
        soilVC = self.newVc(viewController: "Gauge") as! GaugeViewController
        
        tempVC?.units = "˚F"
        soilVC?.units = "%"
        tempVC?.gaugeLabelTemp = "Temperature"
        soilVC?.gaugeLabelTemp = "Moisture"
        
        tempVC?.rangeLabels[0] = "Too Cold"
        tempVC?.rangeLabels[2] = "Too Hot"
        
        
        return [tempVC!,soilVC!]
    }()
    
    func convertToRange(number: Double) -> Double {
        return (number) / (310) * 100
    }
   
    
    

    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.gray
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
}
