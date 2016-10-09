//
//  RestaurantViewController.swift
//  GrubSpot
//
//  Created by Sazan Dauti on 10/9/16.
//  Copyright © 2016 Sazan Dauti. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftHEXColors
import SwiftHTTP

class RestaurantViewController: UIViewController {
    
    var longitude = 0.0
    var latitude = 0.0
    var typeOfFood = ""
    var randomNum = 0
    var onIndex = 0
    
    var restaurants: [Restaurant] = []
    
    let testImg1 = UIImageView()
    let testImg2 = UIImageView()
    let testImg3 = UIImageView()
    let testImg4 = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        //self.showLoading()
        //let url = "http://szntech.com/bc/eagleeats/get.php?cafe=\(self.cafeSel)&day=\(self.onMenuDay)"
        /* let parameters: Parameters = [
         "start": "42.339922,-71.166147",
         "end": "\(latitude),\(longitude)",
         "cat": "\(typeOfFood)"
         ] */
        let url = "http://cscilab.bc.edu/~wudh/grubstuff/info.json"
        //let url = "http://szntech.com/bc/eagleeats/get.php"
        DispatchQueue.global().async {
            Alamofire.request(url, method: .get).validate().responseJSON { response in
                switch response.result {
                case .success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for (_, val) in json {
                            let name = val["name"].stringValue
                            let type = val["type"].stringValue
                            let latitude = val["latitude"].floatValue
                            let longitude = val["longitude"].floatValue
                            let rating = val["rating"].floatValue
                            let img_url = val["img_url"].stringValue
                            let phone = val["phone"].stringValue
                            let street = val["street"].stringValue
                            let city = val["city"].stringValue
                            let state = val["state"].stringValue
                            let zip = val["zip_code"].stringValue
                            let website = val["website"].stringValue
                            
                            print ("Here \(rating)")
                            
                            let tempRest = Restaurant(name: name, type: type, latitude: latitude, longitude: longitude, rating: rating, img_url: img_url, phone: phone, street: street, city: city, state: state, zip: zip, website: website)
                            
                            self.restaurants.append(tempRest)
                            
                        }
                    }
                    self.updateIt()
                case .failure(let error):
                    print(error)
                    
                }
            }
            
        }
        
    }
    
    func updateIt() {
        randomNum = Int(arc4random_uniform(UInt32(2)) + 1)-1
        print(randomNum)
        
        let topBar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 500))
        topBar.backgroundColor = UIColor(hexString: "#2abf88")
        
        testImg1.frame = CGRect(x: self.view.frame.size.width/2-75, y: 50, width: 150, height: 150)
        testImg1.contentMode = .scaleAspectFill
        testImg1.layer.cornerRadius = 75
        testImg1.clipsToBounds = true
        testImg1.downloadedFrom(link: restaurants[randomNum].img_url)
        testImg1.layer.borderColor = UIColor.white.cgColor
        testImg1.layer.borderWidth = 7
        
        let name = UILabel(frame: CGRect(x: 20, y: 220, width: self.view.frame.size.width-40, height: 30))
        name.text = restaurants[randomNum].name
        name.textAlignment = .center
        name.textColor = UIColor.white
        name.font = name.font.withSize(20)
        
        let address = UILabel(frame: CGRect(x: 20, y: 250, width: self.view.frame.size.width-40, height: 30))
        address.text = "\(restaurants[randomNum].street) • \(restaurants[randomNum].city), \(restaurants[randomNum].state) • \(restaurants[randomNum].zip)"
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
        websiteButton.frame = CGRect(x: 10, y: 300, width: self.view.frame.size.width/2-20, height: 50)
        websiteButton.addTarget(self, action: #selector(pressedWebsite), for: .touchUpInside)
        
        let phoneButton = UIButton()
        phoneButton.setTitle("\(restaurants[randomNum].phone)", for: .normal)
        phoneButton.setTitleColor(UIColor(hexString: "#2abf88"), for: .normal)
        phoneButton.layer.cornerRadius = 4.0
        phoneButton.backgroundColor = UIColor(hexString: "#f8f8f8")
        phoneButton.frame = CGRect(x: self.view.frame.size.width/2+10, y: 300, width: self.view.frame.size.width/2-20, height: 50)
        phoneButton.addTarget(self, action: #selector(pressedPhone), for: .touchUpInside)
        
        
        let dirButton = UIButton()
        dirButton.setTitle("Get Directions", for: .normal)
        dirButton.setTitleColor(UIColor(hexString: "#2abf88"), for: .normal)
        dirButton.layer.cornerRadius = 4.0
        dirButton.backgroundColor = UIColor(hexString: "#f8f8f8")
        dirButton.frame = CGRect(x: 10, y: 390, width: self.view.frame.size.width-20, height: 50)
        dirButton.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        
        topBar.addSubview(websiteButton)
        topBar.addSubview(phoneButton)
        topBar.addSubview(dirButton)
        
        self.view.addSubview(topBar)
        
        genSimilar()
    }
    
    
    func pressed(sender: UIButton!) {
        UIApplication.shared.openURL(NSURL(string:"http://maps.apple.com/?saddr=42.339922,-71.166147&daddr=\(restaurants[randomNum].latitude),\(restaurants[randomNum].longitude)")! as URL)

    }
    
    func pressedPhone(sender: UIButton!) {
        
        let numericSet : [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let filteredCharacters = restaurants[randomNum].phone.characters.filter {
            return numericSet.contains($0)
        }
        let filteredString = String(filteredCharacters)
        
        UIApplication.shared.openURL(NSURL(string: "tel://\(filteredString)")! as URL)
    }
    
    func pressedWebsite(sender: UIButton!) {
        UIApplication.shared.openURL(NSURL(string: restaurants[randomNum].website)! as URL)
    }
    
    
    func genSimilar() {
        
        let simLab = UILabel(frame: CGRect(x: 10, y: 475, width: self.view.frame.size.width-20, height: 20))
        simLab.text = "Other Similar Places"
        simLab.textColor = UIColor.white
        simLab.font = simLab.font.withSize(18)
        
        self.view.addSubview(simLab)
        
        testImg2.frame = CGRect(x: 0, y: 500, width: self.view.frame.size.width/2, height: self.view.frame.size.height-500)
        testImg2.contentMode = .scaleAspectFill
        testImg2.clipsToBounds = true
        testImg2.downloadedFrom(link: restaurants[randomNum+1].img_url)
        
        let overlay = UIView(frame: CGRect(x: 0, y: 0, width: testImg2.frame.size.width, height: testImg2.frame.size.height))
        overlay.backgroundColor = UIColor.black
        overlay.layer.opacity = 0.6
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: testImg2.frame.size.width, height: testImg2.frame.size.height))
        label.text = restaurants[randomNum+1].name
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.layer.shadowOpacity = 0.3
        label.layer.shadowRadius = 2.0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width:0, height:1)
        label.font = label.font.withSize(18)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.goTo2(_:)))
        testImg2.addGestureRecognizer(gesture)
        testImg2.isUserInteractionEnabled = true
        
        testImg2.addSubview(overlay)
        testImg2.addSubview(label)
        
        testImg3.frame = CGRect(x: self.view.frame.size.width/2, y: 500, width: self.view.frame.size.width/2, height: self.view.frame.size.height-500)
        testImg3.contentMode = .scaleAspectFill
        testImg3.clipsToBounds = true
        testImg3.downloadedFrom(link: restaurants[randomNum+2].img_url)
        
        let overlay2 = UIView(frame: CGRect(x: 0, y: 0, width: testImg3.frame.size.width, height: testImg3.frame.size.height))
        overlay2.backgroundColor = UIColor.black
        overlay2.layer.opacity = 0.6
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: testImg3.frame.size.width, height: testImg3.frame.size.height))
        label2.text = restaurants[randomNum+2].name
        label2.textColor = UIColor.white
        label2.textAlignment = .center
        label2.layer.shadowOpacity = 0.3
        label2.layer.shadowRadius = 2.0
        label2.layer.shadowColor = UIColor.black.cgColor
        label2.layer.shadowOffset = CGSize(width:0, height:1)
        label2.font = label2.font.withSize(18)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(self.goTo3(_:)))
        testImg3.addGestureRecognizer(gesture2)
        
        testImg3.addSubview(overlay2)
        testImg3.addSubview(label2)
        testImg3.isUserInteractionEnabled = true
        
        self.view.addSubview(testImg2)
        self.view.addSubview(testImg3)
    }
    
    func goTo2(_ sender: UITapGestureRecognizer) {print("here")
        onIndex = randomNum + 1
        performSegue(withIdentifier: "showMore", sender: nil)
    }
    
    func goTo3(_ sender: UITapGestureRecognizer) {
        onIndex = randomNum + 2
        performSegue(withIdentifier: "showMore", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMore" {
            if let destinationVC = segue.destination as? MoreViewController {
                destinationVC.restaurant = restaurants[onIndex]
            }
        }
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
