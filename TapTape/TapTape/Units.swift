//
//  Units.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/25.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import Foundation

let unit_names = ["in", "ft", "yd", "mi", "cm", "m", "km"];
let units = [UnitLength.inches, UnitLength.feet, UnitLength.yards, UnitLength.miles, UnitLength.centimeters, UnitLength.meters, UnitLength.kilometers]

func getTimeElapsedString(_ date : Date) -> String {
    let secondsSincePosted = -date.timeIntervalSinceNow
    let minutes = Int(secondsSincePosted / 60)
    if minutes == 1 {
        return "\(minutes) minute ago"
    } else if minutes < 60 {
        return "\(minutes) minutes ago "
    } else if minutes < 120 {
        return "1 hour ago"
    } else if minutes < 24 * 60 {
        return "\(minutes / 60) hours ago"
    } else if minutes < 48 * 60 {
        return "1 day ago"
    } else {
        return "\(minutes / 1440) days ago"
    }
    
}
