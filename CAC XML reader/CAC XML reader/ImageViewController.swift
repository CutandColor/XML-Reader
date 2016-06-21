//
//  VideoViewController.swift
//  JSON Example
//
//  Created by Patrick Stephen on 1/24/16.
//  Copyright © 2016 pjtnt11. All rights reserved.
//

import UIKit
import Firebase

class ImageViewController: UIViewController
{
    var storageRef:FIRStorageReference!
    
    @IBOutlet var imageView: UIImageView!
    
    var menuActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad()
    {
        storageRef = FIRStorage.storage().reference()
        let imagesRef = storageRef.child("images")
        let imageTitle = UserDefaults.standard().object(forKey: "title") as! String
        let imageName = UserDefaults.standard().object(forKey: "fileName") as! String
        let imageRef = imagesRef.child(imageName)
        
        self.title = imageTitle
        //print(imageName)
        
        self.menuActivityIndicator.frame = CGRect.init(x: 0, y: 0, width: 75, height: 75)
        self.menuActivityIndicator.layer.cornerRadius = 15
        self.menuActivityIndicator.center = self.view.center
        self.menuActivityIndicator.hidesWhenStopped = true
        self.menuActivityIndicator.backgroundColor = UIColor.gray()
        self.menuActivityIndicator.alpha = 0.75
        self.view.addSubview(menuActivityIndicator)
        
        self.view.isUserInteractionEnabled = false
        self.menuActivityIndicator.startAnimating()
        imageRef.data(withMaxSize: 50 * 1024 * 1024, completion: { (data, error) in
            if (error != nil)
            {
                print(error!)
                FIRCrashMessage("The image failed to downlaod")
                fatalError()
            }
            else
            {
                self.imageView.image = UIImage.init(data: data!)
                self.menuActivityIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        })
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
