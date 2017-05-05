//
//  Records.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/25.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import Foundation
import UIKit

var savedRecords: [Record] = []
var lengthRecord: [Record] = []

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func retrieveData() {
    do {
        savedRecords = try context.fetch(Record.fetchRequest())
    } catch {
        print("Fetching Records from Core Data failed :( ")
    }
    lengthRecord.removeAll()
    
    for record in savedRecords {
        if record.isLenRec {
            lengthRecord.append(record)
        }
    }
}

func deleteAllData()
{
    retrieveData()
    for record in savedRecords {
        context.delete(record)
    }
    do {
     try context.save()
    } catch {
        print("Error deleting")
    }
}

func resetAllData() {
    deleteAllData()
    savedRecords.removeAll()
    retrieveData()
}
var photoTaken = false
var calculateStats = false

