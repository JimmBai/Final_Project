//
//  RecordTableViewController.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/25.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import UIKit

class RecordTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recordTableView: UITableView!

    var selectedIndexPath:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recordTableView.delegate = self
        recordTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveData()
        recordTableView.reloadData()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRecords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = recordTableView.dequeueReusableCell(withIdentifier: "recordCell") as? RecordTableViewCell {
            let record = lengthRecord[indexPath.row]
            cell.name.text = record.name
            let index = Int(record.unit)
            let unit = unit_names[index]
            cell.length.text = NSString(format:"Length %.2f %@", record.length, unit) as String
            cell.time.text = getTimeElapsedString(record.date! as Date)
            cell.isUserInteractionEnabled = true
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "recTableToInfo", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "recTableToInfo" {
                if let dest = segue.destination as? InfoViewController {
                    if let path = selectedIndexPath {
                        dest.record = savedRecords[path.row]
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
