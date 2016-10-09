//
//  MoreViewController.swift
//  NewGrub
//
//  Created by Sazan Dauti on 10/9/16.
//  Copyright © 2016 Sazan Dauti. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    let testImg1 = UIImageView()
    
    var restaurant: Restaurant = Restaurant(name: "", type: "", latitude: 0.0, longitude: 0.0, rating: 0.0, img_url: "", phone: "", street: "", city: "", state: "", zip: "", website: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        updateIt()
        // Do any additional setup after loading the view.
    }
    
    func updateIt() {
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        topBar.backgroundColor = UIColor(hexString: "#2abf88")
        
        testImg1.frame = CGRect(x: self.view.frame.size.width/2-75, y: 100, width: 150, height: 150)
        testImg1.contentMode = .scaleAspectFill
        testImg1.layer.cornerRadius = 75
        testImg1.clipsToBounds = true
        testImg1.downloadedFrom(link: restaurant.img_url)
        testImg1.layer.borderColor = UIColor.white.cgColor
        testImg1.layer.borderWidth = 7
        
        let name = UILabel(frame: CGRect(x: 20, y: 300, width: self.view.frame.size.width-40, height: 30))
        name.text = restaurant.name
        name.textAlignment = .center
        name.textColor = UIColor.white
        name.font = name.font.withSize(20)
        
        let address = UILabel(frame: CGRect(x: 20, y: 330, width: self.view.frame.size.width-40, height: 30))
        address.text = "\(restaurant.street) • \(restaurant.city), \(restaurant.state) • \(restaurant.zip)"
        address.textAlignment = .center
        address.textColor = UIColor.white
        address.font = address.font.withSize(13)
        
        topBar.addSubview(name)
        topBar.addSubview(address)
        
        topBar.addSubview(testImg1)
        
        let websiteButton = UIButton()
        websiteButton.setTitle("Yelp", for: .normal)
        websiteButton.setTitleColor(UIColor(hexString: "#2abf88"), for: .normal)
        websiteButton.layer.cornerRadius = 4.0
        websiteButton.backgroundColor = UIColor(hexString: "#f8f8f8")
        websiteButton.frame = CGRect(x: 10, y: 380, width: self.view.frame.size.width/2-20, height: 50)
        websiteButton.addTarget(self, action: #selector(pressedWebsite), for: .touchUpInside)
        
        let phoneButton = UIButton()
        phoneButton.setTitle("\(restaurant.phone)", for: .normal)
        phoneButton.setTitleColor(UIColor(hexString: "#2abf88"), for: .normal)
        phoneButton.layer.cornerRadius = 4.0
        phoneButton.backgroundColor = UIColor(hexString: "#f8f8f8")
        phoneButton.frame = CGRect(x: self.view.frame.size.width/2+10, y: 380, width: self.view.frame.size.width/2-20, height: 50)
        phoneButton.addTarget(self, action: #selector(pressedPhone), for: .touchUpInside)
        
        
        let dirButton = UIButton()
        dirButton.setTitle("Get Directions", for: .normal)
        dirButton.setTitleColor(UIColor(hexString: "#2abf88"), for: .normal)
        dirButton.layer.cornerRadius = 4.0
        dirButton.backgroundColor = UIColor(hexString: "#f8f8f8")
        dirButton.frame = CGRect(x: 10, y: 500, width: self.view.frame.size.width-20, height: 50)
        dirButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        topBar.addSubview(websiteButton)
        topBar.addSubview(phoneButton)
        topBar.addSubview(dirButton)
        
        self.view.addSubview(topBar)

    }

    
    func pressed(sender: UIButton!) {
        UIApplication.shared.openURL(NSURL(string:"http://maps.apple.com/?saddr=42.339922,-71.166147&daddr=\(restaurant.latitude),\(restaurant.longitude)")! as URL)
        
    }
    
    func pressedPhone(sender: UIButton!) {
        
        let numericSet : [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let filteredCharacters = restaurant.phone.characters.filter {
            return numericSet.contains($0)
        }
        let filteredString = String(filteredCharacters)
        
        UIApplication.shared.openURL(NSURL(string: "tel://\(filteredString)")! as URL)
    }
    
    func pressedWebsite(sender: UIButton!) {
        UIApplication.shared.openURL(NSURL(string: restaurant.website)! as URL)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
