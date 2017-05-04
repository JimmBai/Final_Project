//
//  InfoViewController.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/25.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import UIKit
import MapKit

class InfoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var mapView: MKMapView!
    var record:Record?
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let rec = record {
            let initialLoc = CLLocation(latitude:rec.latitude,
                                            longitude:rec.longitude)
            centerMapOnLocation(location: initialLoc)
            imageView.image = UIImage(data: rec.photo! as Data)
            let annotation = MKPointAnnotation()
            annotation.coordinate =
                CLLocationCoordinate2D(
                    latitude: rec.latitude,
                    longitude: rec.longitude)
            mapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion =
            MKCoordinateRegionMakeWithDistance(
                location.coordinate,
                regionRadius * 2.0,
                regionRadius * 2.0)
        mapView.setRegion(coordinateRegion,animated: true)
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
