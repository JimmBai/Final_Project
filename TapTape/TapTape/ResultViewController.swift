//
//  ResultViewController.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/25.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var resultDisplay: UILabel!
    @IBOutlet var referenceLength: UITextField!
    @IBOutlet var inputPickerView: UIPickerView!
    @IBOutlet var resultPickerView: UIPickerView!
    var input_unit = 0
    var output_unit = 0
    var length:Double?
    var unit:Int?
    var photo:UIImage?
    var lgt:Double?
    var lat:Double?
    
    var measureStats:Measure?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.inputPickerView.dataSource = self;
        self.inputPickerView.delegate = self;
        
        self.resultPickerView.dataSource = self;
        self.resultPickerView.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unit_names.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unit_names[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView == inputPickerView) {
            input_unit = row
        } else {
            output_unit = row
        }
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        if let input_length = referenceLength.text {
            if let num = Double(input_length) {
                if let measure = measureStats {
                    measure.set_ref_length(num)
                    let result = measure.get_measured_length(input_unit, output_unit)
                    if (result > Measurement(value: 0.0, unit: units[0])) {
                        resultDisplay.text = NSString(format:"The length is %.2f", result.value) as String
                        length = result.value
                        unit = output_unit
                        calculateStats = true;
                    }
                }
            }
        }
        
    }
    
    @IBAction func saveStats(_ sender: UIButton) {
        if (calculateStats) {
            performSegue(withIdentifier: "resultToSave", sender: self)
            calculateStats = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "resultToSave" {
                if let dest = segue.destination as? SaveViewController {
                    if let obj_len = length {
                        dest.obj_length = obj_len
                        dest.unit = unit
                        dest.photo = photo
                        if let latitude = lat {
                            dest.latitude = latitude
                        }
                        if let longitude = lgt {
                            dest.longitude = longitude
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
