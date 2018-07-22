//
//  ViewController.swift
//  Deveotional
//
//  Created by Kuramsetty Harish on 21/07/18.
//  Copyright © 2018 iDreams. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    @IBOutlet weak var tblview: UITableView!
    var imageDataArray:[Hits]?
    
    var cache:NSCache<AnyObject, AnyObject>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cache = NSCache()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Downloading a single image with image
        let store = Storage.storage()
        let storeRef = store.reference()
        let logoRef = storeRef.child("images/india.png")
        logoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error \(error)")
            } else {
                let logoImage = UIImage(data: data!)
                let imageView = UIImageView()
                imageView.image = logoImage
                imageView.frame = CGRect(x: 150, y: 120, width: 50, height: 50)
                self.view .addSubview(imageView)
            }
        }
        
        
        
        
    }
    
    fileprivate func callAPi(searchText: String){
        Webservices.sharedInstance.postApicall(url: "https://pixabay.com/api/?key=9611937-e5fe75bb101e83346e7e50337&q=\(searchText)", params: [:], sucess: { (data, code) in
            let decoder = try? JSONDecoder().decode(ImageDta.self, from: data)
            self.imageDataArray = decoder?.hits
            DispatchQueue.main.async {
                self.tblview.reloadData()
            } }) { (code) in
                
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension ViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.callAPi(searchText: searchBar.text!)
    }
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = imageDataArray?.count{
            return count
        }else{
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageListTableViewCell", for: indexPath)
            as! ImageListTableViewCell
        cell.downloadImageView.image = UIImage(named: "Placeholder")
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject)  != nil){
            cell.downloadImageView.image = self.cache.object(forKey: indexPath.row as AnyObject) as? UIImage
            self.isCahceUpdateRequired(withRow: indexPath as NSIndexPath)
            
        }else{
            DispatchQueue.global().async {
                do {
                    let url = self.imageDataArray?[indexPath.row].previewURL
                    let data = try Data(contentsOf:URL(string: url!)!)
                    
                    DispatchQueue.main.async {
                        if let currentVisiblecell:ImageListTableViewCell = tableView.cellForRow(at: indexPath) as? ImageListTableViewCell{
                            self.cache.setObject(UIImage(data: data)!, forKey: indexPath.row as AnyObject)
                            currentVisiblecell.downloadImageView.image = UIImage(data: data)
                        }
                    }
                }catch{
                    print("error found")
                }
            }
        }
        
        return cell
    }
    
    func isCahceUpdateRequired(withRow: NSIndexPath){
        DispatchQueue.global().async {
            let url = self.imageDataArray?[withRow.row].previewURL
            do{
                let data = try Data(contentsOf:URL(string: url!)!)
                
                //this will check the cache image and server image are same or not
                if !(self.image(image1: (self.cache.object(forKey: withRow.row as AnyObject) as? UIImage)!, isEqualTo: UIImage(data: data)!))
                {
                    self.cache.setObject(UIImage(data: data)!, forKey: withRow.row as AnyObject)
                    DispatchQueue.main.async {
                        self.tblview.reloadRows(at: [withRow as IndexPath], with: .fade)
                    }
                }
            }catch{
                
            }
        }
    }
    
    func image(image1: UIImage, isEqualTo image2: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(image1)! as NSData
        let data2: NSData = UIImagePNGRepresentation(image2)! as NSData
        print(data1.isEqual(data2))
        return data1.isEqual(data2)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

