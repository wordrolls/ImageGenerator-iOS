//
//  ViewController.swift
//  ImageGenerator-iOS
//
//  Created by Europa on 27/04/19.
//  Copyright © 2019 Sudeep. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var wordView: UIView?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        wordView?.backgroundColor = UIColor(red: 179.0/255, green: 41.0/255, blue: 80.0/255, alpha: 1.0)
    }
    
    @IBAction func saveTapped(sender: UIButton)
    {
        // https://stackoverflow.com/a/11518135
        // generate
        let captureView = wordView
        UIGraphicsBeginImageContextWithOptions(captureView!.bounds.size, captureView!.isOpaque, 0.0)
        captureView?.layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageRect = CGRect(x: 0, y: 0, width: 1080, height: 1080)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, captureView!.isOpaque, 1.0)
        screenshot?.draw(in: imageRect)
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // save
        if let _ = finalImage {
            saveImage(image: finalImage!)
        }
        else {
            print("no image!!!")
        }
    }
    
    func saveImage(image: UIImage)
    {
        // https://stackoverflow.com/a/32837120
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = "image.png"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // get your UIImage png data representation and check if the destination file url already exists
        if let data = image.pngData()
        {
            // delete previous
            if (!FileManager.default.fileExists(atPath: fileURL.path))
            {
                do
                {
                    try FileManager.default.removeItem(at: fileURL)
                    print("old file deleted")
                }
                catch {
                    print("unable to delete old file:", error)
                }
            }
            
            // save
            do
            {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
}
