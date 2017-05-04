//
//  SaveViewController.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/25.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import UIKit
import CoreLocation

class SaveViewController: UIViewController, CLLocationManagerDelegate {

    var obj_length:Double?
    var latitude:Double?
    var longitude:Double?
    var photo:UIImage?
    var unit:Int?
    
    @IBOutlet weak var nameInput: UITextField!
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if !CLLocationManager.locationServicesEnabled()
        {
            manager.requestWhenInUseAuthorization()
        }
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest

        manager.requestLocation()
        if let userLocation:CLLocation = manager.location {
            latitude = userLocation.coordinate.latitude
            longitude = userLocation.coordinate.longitude
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
        } else {
            print("Cannot get geo")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        manager.stopUpdatingLocation()
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
    }
    
    func presentConfirmationAlert() {
        let alert = UIAlertController(title: "Record Saved!", message: "You can view your new record by clicking `Records`", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (alert: UIAlertAction!) in
            _ = self.navigationController?.popToRootViewController(animated: true) }
        ))
        self.present(alert, animated: true, completion: nil)
    }


    @IBAction func saveData(_ sender: UIButton) {
        if let text = nameInput.text {
            if photoTaken {
                let imageData = UIImageJPEGRepresentation(photo!, 0.6)
                let compressedJPGImage = UIImage(data: imageData!)
                UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
            }
            saveMeasureData(photo, text)
            presentConfirmationAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func saveMeasureData (_ storeImage : UIImage?, _ name : String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let save_image = storeImage {
            
            let context =  appDelegate.persistentContainer.viewContext
            let record = Record(context: context)
            record.name = name
            record.isDisplayed = false

            record.isLenRec = true
            record.photo = UIImagePNGRepresentation(save_image) as NSData?
            record.date = NSDate()
            if let lat = latitude {
                record.latitude = lat
            } else {
                record.latitude = 0.0
            }
            if let lgt = longitude {
                record.longitude = lgt
            } else {
                record.longitude = 0.0
            }
            record.unit = Int16(unit!)
            record.length = obj_length!
            
            appDelegate.saveContext()
            print("Saved")
        }
        
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
