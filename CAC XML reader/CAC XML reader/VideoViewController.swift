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

class VideoViewController: UIViewController
{
    @IBOutlet var playVideoButton: UIButton!
    
    var videoUrl:URL!
    var storageRef:FIRStorageReference!

    var menuActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad()
    {
        storageRef = FIRStorage.storage().reference()
        let videosRef = storageRef.child("videos")
        let videoTitle = UserDefaults.standard().object(forKey: "title") as! String
        let videoName = UserDefaults.standard().object(forKey: "fileName") as! String
        let videoRef = videosRef.child(videoName)
        
        self.menuActivityIndicator.frame = CGRect.init(x: 0, y: 0, width: 75, height: 75)
        self.menuActivityIndicator.layer.cornerRadius = 15
        self.menuActivityIndicator.center = self.view.center
        self.menuActivityIndicator.hidesWhenStopped = true
        self.menuActivityIndicator.backgroundColor = UIColor.gray()
        self.menuActivityIndicator.alpha = 0.75
        self.view.addSubview(menuActivityIndicator)
        
        self.title = videoTitle
        //print(videoName)
        
        self.playVideoButton.isHidden = true
        self.view.isUserInteractionEnabled = false
        self.menuActivityIndicator.startAnimating()
        videoRef.downloadURL { (URL, error) in
            if (error != nil)
            {
                print(error!)
                FIRCrashMessage("The video failed to downlaod")
                fatalError()
            }
            else
            {
                self.videoUrl = URL
                
                do
                {
                    try self.playVideo()
                }
                catch
                {
                    print("Error")
                }

            }
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func playVideo(_ sender: AnyObject)
    {
        self.playVideoButton.isHidden = true
        self.view.isUserInteractionEnabled = false
        self.menuActivityIndicator.startAnimating()
        do
        {
            try playVideo()
        }
        catch
        {
            print("Error")
            fatalError()
        }
    }
    
    private func playVideo() throws
    {
        print(videoUrl)
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        let player = AVPlayer(url: videoUrl)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true)
        {
            player.play()
            self.menuActivityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            self.playVideoButton.isHidden = false
        }
    }
    
    enum AppError : ErrorProtocol
    {
        case invalidResource(String, String)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
