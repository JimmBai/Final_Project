//
//  Measure.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/28.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Measure {
    
    var ref_obj_start_loc:CGPoint?
    var ref_obj_end_loc:CGPoint?
    var measured_obj_start_loc:CGPoint?
    var measured_obj_end_loc:CGPoint?
    var ref_obj_len:Double?
    
    init () {
        
    }
    
    func reset() {
        ref_obj_start_loc = nil
        ref_obj_end_loc = nil
        measured_obj_start_loc = nil
        measured_obj_end_loc = nil
        ref_obj_len = nil
    }
    
    func set_ref_start(_ loc: CGPoint) {
        self.ref_obj_start_loc = loc
    }
    
    func set_ref_end(_ loc:CGPoint) {
        self.ref_obj_end_loc = loc
    }
    
    func set_measured_start(_ loc:CGPoint) {
        self.measured_obj_start_loc = loc
    }
    
    func set_measured_end(_ loc:CGPoint) {
        self.measured_obj_end_loc = loc
    }
    
    func set_ref_length(_ length:Double) {
        if length > 0 {
            self.ref_obj_len = length
        }
    }
    
    func get_measured_length(_ input_unit:Int, _ output_unit:Int) -> Measurement<UnitLength> {
        if let ref_len = ref_obj_len {
            if let ref_start = ref_obj_start_loc {
                if let ref_end = ref_obj_end_loc {
                    if let measured_start = measured_obj_start_loc {
                        if let measured_end = measured_obj_end_loc {
                            let xDist = ref_start.x - ref_end.x
                            let yDist = ref_start.y - ref_end.y
                            let ref_line_len = Double(sqrt((xDist * xDist) + (yDist * yDist)))
                            
                            let m_xDist = measured_start.x - measured_end.x
                            let m_yDist = measured_start.y - measured_end.y
                            let m_line_len = Double(sqrt((m_xDist * m_xDist) + (m_yDist * m_yDist)))
                            
                            let actual_len = ref_len * m_line_len / ref_line_len
                            let actual_len_w_unit = Measurement(value: actual_len, unit: units[input_unit])
                            return actual_len_w_unit.converted(to: units[output_unit])
                        }
                    }
                }
            }
        }
        return Measurement(value: -1.0, unit: units[0])
    }
}
