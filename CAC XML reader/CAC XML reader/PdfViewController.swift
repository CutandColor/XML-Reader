//
//  VideoViewController.swift
//  JSON Example
//
//  Created by Patrick Stephen on 1/24/16.
//  Copyright © 2016 pjtnt11. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class PdfViewController: UIViewController
{
    var videoUrl:URL!
    var storageRef:FIRStorageReference!
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad()
    {
        storageRef = FIRStorage.storage().reference()
        let pdfsRef = storageRef.child("PDFs")
        let pdfTitle = UserDefaults.standard().object(forKey: "title") as! String
        let pdfName = UserDefaults.standard().object(forKey: "fileName") as! String
        let pdfRef = pdfsRef.child(pdfName)
        
        self.title = pdfTitle
        //print(videoName)
        
        pdfRef.downloadURL { (pdfUrl, error) in
            if (error != nil)
            {
                print(error!)
                FIRCrashMessage("The video failed to downlaod")
                fatalError()
            }
            else
            {
                let url : URL! = pdfUrl
                self.webView.loadRequest(URLRequest(url: url))
            }
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
