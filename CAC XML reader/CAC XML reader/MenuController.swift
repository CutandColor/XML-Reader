//
//  MenuController.swift
//  JSON Example
//
//  Created by Patrick Stephen on 4/23/16.
//  Copyright © 2016 pjtnt11. All rights reserved.
//

import UIKit
import Firebase

class MenuController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var menuTableView: UITableView!
    
    enum selectionType
    {
        case menu
        case video, image, pdf
    }
    
    var titles = [String]()
    var files = [String]()
    var keys = [String]()
    var selectionTypes = [selectionType]()
    
    var databaseRef:FIRDatabaseReference!
    
    var menuTitle:String!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:MenuCell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuCell
        
        cell.cellLabel.text = titles[(indexPath as NSIndexPath).row]
        
        if selectionTypes[(indexPath as NSIndexPath).row] == selectionType.menu
        {
            cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if selectionTypes[(indexPath as NSIndexPath).row] == .video
        {
            performSegue(withIdentifier: "playVideo", sender: self)
        }
        else if selectionTypes[(indexPath as NSIndexPath).row] == .image
        {
            performSegue(withIdentifier: "showImage", sender: self)
        }
        else if selectionTypes[(indexPath as NSIndexPath).row] == .pdf
        {
            performSegue(withIdentifier: "showPDF", sender: self)
        }
        else if selectionTypes[(indexPath as NSIndexPath).row] == .menu
        {
            performSegue(withIdentifier: "showNextPage", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        let name = files[(indexPath as NSIndexPath).row]
        let title = titles[(indexPath as NSIndexPath).row]
        UserDefaults.standard().set(title, forKey: "title")
        UserDefaults.standard().set(name, forKey: "fileName")
        return indexPath
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if databaseRef == nil
        {
            databaseRef = FIRDatabase.database().reference()
        }
        
        if menuTitle != nil
        {
            self.title = menuTitle
        }
        
        databaseRef.keepSynced(true)
        
        let _ = databaseRef.observe(.value, with: { (snapshot) -> Void in
            self.titles.removeAll()
            let _ = self.databaseRef.observe(.childAdded, with: { (snapshot) -> Void in
                
                if let data = snapshot.value as? [String:String]
                {
                    if snapshot.value!["video"] != nil
                    {
                        self.titles.append(data["title"]!)
                        self.files.append(data["video"]!)
                        self.keys.append(snapshot.key)
                        self.selectionTypes.append(selectionType.video)
                    }
                    else if snapshot.value!["image"] != nil
                    {
                        self.titles.append(data["title"]!)
                        self.files.append(data["image"]!)
                        self.keys.append(snapshot.key)
                        self.selectionTypes.append(selectionType.image)
                    }
                    else if snapshot.value!["pdf"] != nil
                    {
                        self.titles.append(data["title"]!)
                        self.files.append(data["pdf"]!)
                        self.keys.append(snapshot.key)
                        self.selectionTypes.append(selectionType.pdf)
                    }
                    else
                    {
                        FIRCrashMessage("There was an error finding the file type")
                        fatalError()
                    }
                    
                }
                else
                {
                    for case let snap as FIRDataSnapshot in snapshot.children
                    {
                        if snap.key == "title"
                        {
                            let data = snap.value
                            self.titles.append(data as! String)
                            self.files.append("")
                            self.keys.append(snapshot.key)
                            self.selectionTypes.append(.menu)
                        }
                    }
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    self.menuTableView.reloadData()
                })
            })
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "showNextPage")
        {
            let destinationViewController:MenuController = segue.destinationViewController as! MenuController
            let selectedRow = self.menuTableView.indexPathForSelectedRow?.row
            
            destinationViewController.databaseRef = databaseRef.child(keys[selectedRow!])
            destinationViewController.menuTitle = self.titles[selectedRow!]
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
