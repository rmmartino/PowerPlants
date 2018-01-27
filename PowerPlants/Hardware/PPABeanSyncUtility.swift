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
    func didCollectMeasurement(bean: PTDBean, type: String, value: String)
    func didDisconnectFromBean(bean: PTDBean)
}

public class PPABeanSyncUtility: NSObject, PTDBeanManagerDelegate, PTDBeanDelegate
{
    static let shared = PPABeanSyncUtility()
    var beanyManager: PTDBeanManager?
    var yourBean: PTDBean?
    var lightState: Bool = false
    
    var delegate: PPABeanSyncDelegate? = nil
    
    var activeBeans: [UUID: PTDBean] = [:]
    
    override init()
    {
        super.init()
        beanyManager = PTDBeanManager()
        beanyManager?.delegate = self
    }
    
    func startScanning()
    {
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
            startScanning()
            if let e = scanError
            {
                print(e)
            }
            else
            {
                print("Please turn on your Bluetooth")
            }
        }
    }

    public func beanManager(_ beanManager: PTDBeanManager!, didDiscover bean: PTDBean!, error: Error!)
    {
        if let e = error
        {
            print(e)
        }
        
        print("Found a Bean: \(bean.name)")
        
        if bean.name == "Bean"
        {
            print("connecting...")
            yourBean = bean
           connectToBean(bean: yourBean!)
        }
    }

    func connectToBean(bean: PTDBean)
    {
        var error: NSError?
        beanyManager?.connect(to: bean, withOptions: [:], error: &error)
        
        if error != nil
        {
            activeBeans[bean.identifier] = bean
            delegate?.didConnectToBean(bean: bean)
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
        startScanning()
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
                    var key = array[0]
                    var val = array[1]
                    
                    delegate?.didCollectMeasurement(bean: bean, type: key, value: val)
                    
                    print("\(key): \(val)")
                }
            }
        }
    }
    
    public func beanManager(_ beanManager: PTDBeanManager!, didConnect bean: PTDBean!, error: Error!)
    {
        bean.delegate = self as! PTDBeanDelegate
    }
}
