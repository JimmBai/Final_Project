//
//  ViewController.swift
//  TapTape
//
//  Created by Jim Bai on 2017/4/13.
//  Copyright © 2017年 Jim Bai. All rights reserved.
//

import UIKit
import AssetsLibrary
import CoreLocation

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!

    var scrollImages: [UIImage] = [#imageLiteral(resourceName: "sample1"), #imageLiteral(resourceName: "sample2"), #imageLiteral(resourceName: "sample3")]
    var scrollRecords:[Record?] = [nil, nil, nil]
    var scrollWidth : CGFloat = UIScreen.main.bounds.size.width
    var scrollHeight : CGFloat = UIScreen.main.bounds.size.height - 240
    var selectImage:UIImage?;

    let imagePicker = UIImagePickerController()
    var changeDisplay = true
    var latitude:Double?
    var longitude:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        scrollView?.contentSize = CGSize(width: (scrollWidth * 3), height: scrollHeight)
        scrollView?.delegate = self;
        scrollView?.isPagingEnabled=true
//        deleteAllData()
//        savedRecords.removeAll()
        
        retrieveData()
        
        refreshScroll()
        
        imagePicker.delegate = self
    }

    func loadImageFromLib() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func takePhoto(_ sender: UIButton) {
        self.performSegue(withIdentifier: "mainToImageTaker", sender: self)
    }
    
    @IBAction func loadImage(_ sender: UIButton) {
        changeDisplay = false
        loadImageFromLib()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var proceed = false
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectImage = pickedImage
            proceed = true
        }

        dismiss(animated: true, completion: { () in
            if (proceed && !self.changeDisplay) {
                photoTaken = false
                self.performSegue(withIdentifier: "mainToImageMeasure", sender: self)
            } else if (proceed && self.changeDisplay) {
                self.saveDisplayImage()
            }
        })
        
    }
    
    @IBAction func changePage(_ sender: Any) {
        scrollView!.scrollRectToVisible(CGRect( x: scrollWidth * CGFloat ((pageControl?.currentPage)!), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
    
    @IBAction func changeDisplayImage(_ sender: UIButton) {
        changeDisplay = true
        loadImageFromLib()
    }
    
    @IBAction func pastRecords(_ sender: UIButton) {
        performSegue(withIdentifier: "mainToRecTable", sender: self)
    }
    
    func refreshScroll () {
        
        if let views = scrollView?.subviews {
            for view in views {
                view.removeFromSuperview()
            }
        }
        
        for record in savedRecords {
            if (record.isDisplayed) {
                let index = Int(record.displayIndex)
                if let image = UIImage(data:(record.photo!) as Data) {
                    scrollImages[index] = image
                    scrollRecords[index] = record
                }
            }
        }
        
        for i in 0...2 {
            let imgView = UIImageView.init()
            imgView.frame = CGRect(x: scrollWidth * CGFloat (i), y: 0, width: scrollWidth,height: scrollHeight)
            if i == 0 {
                imgView.image = scrollImages[0]
            }
            
            if i == 1 {
                imgView.image = scrollImages[1]
            }
            
            if i == 2 {
                imgView.image = scrollImages[2]
            }
            scrollView?.addSubview(imgView)
        }
    }
    
    func saveDisplayImage() {
        var name = "display0"
        if (pageControl?.currentPage == 1) {
            name = "display1"
        } else if (pageControl?.currentPage == 2) {
            name = "display2"
        }

        saveData (selectImage, true, name)
    }
    
    func saveData (_ storeImage : UIImage?, _ isDisplay : Bool, _ name : String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let save_image = storeImage {
            
            let context =  appDelegate.persistentContainer.viewContext
            let record = Record(context: context)
            record.name = name
            record.isDisplayed = isDisplay
            var idx = 0;
            if let index = pageControl?.currentPage {
                record.displayIndex = Int16(index)
                idx = index
            }
            record.isLenRec = !isDisplay
            record.photo = UIImagePNGRepresentation(save_image) as NSData?
            record.date = NSDate()
            
            appDelegate.saveContext()
            print("Saved")
            if (isDisplay) {
                if let rec = scrollRecords[idx] {
                    rec.isDisplayed = false
                }
                savedRecords[idx] = record
                refreshScroll()
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndiactorForCurrentPage()
    }
    
    func setIndiactorForCurrentPage()  {
        let page = (scrollView?.contentOffset.x)!/scrollWidth
        pageControl?.currentPage = Int(page)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "mainToImageMeasure" {
                if let dest = segue.destination as? ImageMeasureViewController {
                    if let image = selectImage {
                        dest.selectedImage = image
                        if let lgt = longitude {
                            dest.lgt = lgt
                        }
                        if let lat = latitude {
                            dest.lat = lat
                        }
                    }
                }
            }
        }
    }
}

