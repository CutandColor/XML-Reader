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
    var videoUrl:URL!
    var storageRef:FIRStorageReference!

    
    override func viewDidLoad()
    {
        storageRef = FIRStorage.storage().reference()
        let videosRef = storageRef.child("videos")
        let videoTitle = UserDefaults.standard().object(forKey: "title") as! String
        let videoName = UserDefaults.standard().object(forKey: "fileName") as! String
        let videoRef = videosRef.child(videoName)
        
        self.title = videoTitle
        //print(videoName)
        
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
        do
        {
            try playVideo()
        }
        catch
        {
            print("Error")
        }
    }
    
    private func playVideo() throws
    {
        print(videoUrl)
        let player = AVPlayer(url: videoUrl)
        let playerController = AVPlayerViewController()
        playerController.player = player
        self.present(playerController, animated: true)
        {
            player.play()
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
