//
//  ImageMeasureViewController.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/25.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import UIKit

class ImageMeasureViewController: UIViewController {

    @IBOutlet var imageDisplay: UIImageView!
    var selectedImage:UIImage? = UIImage(named:"sample1")
    @IBOutlet var tapRefObjButton: UIButton!
    @IBOutlet var tapMeasureObjButton: UIButton!
    @IBOutlet var calculateButton: UIButton!
    var tapRef:Bool = false
    var tapMeasure:Bool = false
    var tapRefCnt:Int = 0
    var tapMeasureCnt:Int = 0
    var measureObj:Measure?
    var ref_start:CAShapeLayer?
    var ref_end:CAShapeLayer?
    var m_start:CAShapeLayer?
    var m_end:CAShapeLayer?
    var ref_line:CAShapeLayer?
    var m_line:CAShapeLayer?
    var lgt:Double?
    var lat:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageDisplay.image = selectedImage
        measureObj = Measure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        let touchLocation: CGPoint = recognizer.location(in: recognizer.view)
        if (tapRefCnt > 1) {
            tapRef = false
        }
        if (tapMeasureCnt > 1) {
            tapMeasure = false
        }
        if (tapRef || tapMeasure) {
            drawTapPoint(touchLocation, recognizer.view!)
        }
    }
    
    func drawTapPoint(_ touchLocation:CGPoint, _ imageView:UIView) {

        let circlePath = UIBezierPath(arcCenter: CGPoint(x: touchLocation.x,y: touchLocation.y), radius: CGFloat(3), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        var dot_color = UIColor.blue.cgColor
        
        if (tapRef) {
            if (tapRefCnt == 0) {
                measureObj?.set_ref_start(touchLocation)
                ref_start = shapeLayer
            } else {
                measureObj?.set_ref_end(touchLocation)
                ref_end = shapeLayer
                
                drawLine((measureObj?.ref_obj_start_loc)!, touchLocation, true, imageView)
            }
            tapRefCnt += 1
        } else {
            if (tapMeasureCnt == 0) {
                measureObj?.set_measured_start(touchLocation)
                m_start = shapeLayer
            } else {
                measureObj?.set_measured_end(touchLocation)
                m_end = shapeLayer
                drawLine((measureObj?.measured_obj_start_loc)!, touchLocation, false, imageView)
            }
            tapMeasureCnt += 1
            dot_color = UIColor.red.cgColor
        }
        
        shapeLayer.fillColor = dot_color
        shapeLayer.strokeColor = dot_color
        
        imageView.layer.addSublayer(shapeLayer)
    }
    
    func drawLine(_ start:CGPoint, _ end:CGPoint, _ isRef:Bool, _ imageView:UIView) {
        let aPath = UIBezierPath()
        aPath.move(to: start)
        aPath.addLine(to: end)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = aPath.cgPath
        var dot_color = UIColor.red.cgColor
        if (isRef) {
            dot_color = UIColor.blue.cgColor
            ref_line = shapeLayer
        } else {
            m_line = shapeLayer
        }
        shapeLayer.fillColor = dot_color
        shapeLayer.strokeColor = dot_color
        shapeLayer.lineWidth = 3.0
        imageView.layer.addSublayer(shapeLayer)
    }
    
    @IBAction func tapRefPos(_ sender: UIButton) {
        if (tapMeasureCnt == 1) {
            return
        }
        tapRef = true
        tapMeasure = false
        tapRefCnt = 0
        if let ref_start_point = ref_start {
            ref_start_point.removeFromSuperlayer()
        }
        if let ref_end_point = ref_end {
            ref_end_point.removeFromSuperlayer()
        }
        if let r_line = ref_line {
            r_line.removeFromSuperlayer()
        }
    }
    
    @IBAction func tapMeasurePos(_ sender: UIButton) {
        if (tapRefCnt == 1) {
            return
        }
        tapMeasure = true
        tapRef = false
        tapMeasureCnt = 0
        if let m_start_point = m_start {
            m_start_point.removeFromSuperlayer()
        }
        if let m_end_point = m_end {
            m_end_point.removeFromSuperlayer()
        }
        if let m_line_layer = m_line {
            m_line_layer.removeFromSuperlayer()
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        tapRef = false
        tapMeasure = false
        self.performSegue(withIdentifier: "imageMeasureToResult", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "imageMeasureToResult" {
                if let dest = segue.destination as? ResultViewController {
                    if let measure = measureObj {
                        dest.measureStats = measure
                        dest.photo = selectedImage
                        if let latitude = lat {
                            dest.lat = latitude
                        }
                        if let longitude = lgt {
                            dest.lgt = longitude
                        }
                    }
                }
            }
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
