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
    
    var menuActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad()
    {
        storageRef = FIRStorage.storage().reference()
        let pdfsRef = storageRef.child("PDFs")
        let pdfTitle = UserDefaults.standard().object(forKey: "title") as! String
        let pdfName = UserDefaults.standard().object(forKey: "fileName") as! String
        let pdfRef = pdfsRef.child(pdfName)
        
        self.title = pdfTitle
        //print(videoName)
        
        self.menuActivityIndicator.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        self.menuActivityIndicator.layer.cornerRadius = 15
        self.menuActivityIndicator.center = self.view.center
        self.menuActivityIndicator.hidesWhenStopped = true
        self.menuActivityIndicator.backgroundColor = UIColor.gray()
        self.menuActivityIndicator.alpha = 0.5
        self.view.addSubview(menuActivityIndicator)
        
        self.view.isUserInteractionEnabled = false
        self.menuActivityIndicator.startAnimating()
        pdfRef.downloadURL { (pdfUrl, error) in
            if (error != nil)
            {
                print(error!)
                FIRCrashMessage("The PDF failed to downlaod")
                fatalError()
            }
            else
            {
                let url : URL! = pdfUrl
                self.webView.loadRequest(URLRequest(url: url))
                
                while self.webView.isLoading{}
                
                self.menuActivityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
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
