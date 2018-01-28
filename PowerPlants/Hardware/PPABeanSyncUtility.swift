//
//  PPABeanSyncUtility.swift
//  PowerPlants
//
//  Created by Rebecca Martino on 1/27/18.
//  Copyright © 2018 Alyssa Schilke. All rights reserved.
//

import Foundation
import Bean_iOS_OSX_SDK

protocol PPABeanSyncDelegate
{
    func didConnectToBean(bean: PTDBean)
    func didCollectMeasurement(bean: PTDBean, temp: String, soil: String)
    func didDisconnectFromBean(bean: PTDBean)
}

public class PPABeanSyncUtility: NSObject, PTDBeanManagerDelegate, PTDBeanDelegate
{
    static let shared = PPABeanSyncUtility()
    var beanyManager: PTDBeanManager?
    var yourBean: PTDBean?
    var lightState: Bool = false
    var dataToOutput: String = ""
    
    var delegate: PPABeanSyncDelegate? = nil
    
    var activeBeans: [UUID: PTDBean] = [:]
    
    var lookingForUUID: String? = nil
    
    override init()
    {
        super.init()
        beanyManager = PTDBeanManager()
        beanyManager?.delegate = self
    }
    
    func startScanning(uuid: String)
    {
        self.lookingForUUID = uuid;
        var error: NSError?
        beanyManager!.startScanning(forBeans_error: &error)
        if let e = error
        {
            print(e)
        }
    }
    
    public func beanManagerDidUpdateState( _ beanManager: PTDBeanManager!)
    {
        var scanError: NSError?
        
        if beanManager!.state == BeanManagerState.poweredOn
        {
            if let e = scanError
            {
                print(e)
            }
            else
            {
                print("Please turn on your Bluetooth")
            }
            
            if let uuid = lookingForUUID {
                startScanning(uuid: uuid)
            }
        }
    }

    public func beanManager(_ beanManager: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!)
    {
        if let e = error
        {
            print(e)
        }
        
        print("Found a Bean: \(bean.name) - \(bean.identifier) ")
        if let uuid = lookingForUUID {
            if bean.identifier == UUID.init(uuidString: uuid)
            {
                print("connecting...")
                yourBean = bean
                connectToBean(bean: yourBean!)
            }
        }
    }

    func connectToBean(bean: PTDBean)
    {
       
        var error: NSError?
        beanyManager?.connect(to: bean, withOptions: [:], error: &error)
        
        if error != nil
        {
             print("cone!")
            activeBeans[bean.identifier] = bean
            delegate?.didConnectToBean(bean: bean)
        }
        else{
            print(error)
        }
    }
    
    func sendSerialData(beanState: NSData)
    {
        yourBean?.sendSerialData(beanState as Data!)
    }
    
    public func beanManager(_ beanManager: PTDBeanManager!, didDisconnectBean bean: PTDBean!, error: Error!) {
        
        print(activeBeans)
        activeBeans.removeValue(forKey: bean.identifier!)
        print("Bye")
        print(activeBeans)
        if let uuid = lookingForUUID {
            startScanning(uuid: uuid)
        }
    }
    
    public func bean(_ bean: PTDBean!, serialDataReceived data: Data!)
    {
        print("DWDwddw")
        var str = String.init(data: data, encoding: String.Encoding.ascii)
        
        if(str != "\n" && str != "\r")
        {
            if let output = str
            {
                print("Whole string: \(str ?? "")")
                let array = output.components(separatedBy: ":")
                if(array.count == 2)
                {
                    var soil = array[0]
                    var temp = array[1]
                    
                    delegate?.didCollectMeasurement(bean: bean, temp: "\(temp)", soil: "\(soil)")
                  
                    print("\(temp) : \(soil) ")
                }
            }
        }
    }
    
    public func beanManager(_ beanManager: PTDBeanManager!, didConnect bean: PTDBean!, error: Error!)
    {
        bean.delegate = self as! PTDBeanDelegate
    }
}
