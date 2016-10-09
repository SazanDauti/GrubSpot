import UIKit
import GooglePlaces
import GoogleMaps
import SwiftHEXColors


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let theTableHeader: UIView = UIView()
    let theTable: UITableView = UITableView()
    
    var goingToLoc: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    var placeLabelHolder: CGFloat = 1
    
    var onType: Int = 0
    
    let foodcontainer = UIView()
    let button1 = UIImageView()
    let titleText1 = UILabel()
    let titleText2 = UILabel()
    let plusButton = UIImageView()
    let finalTitle = UILabel()
    
    let modernArrow = UIImageView()
    
    var isCheckFood = 0
    
    var mapView: UIView = UIView()
    let bottomBar: UIView = UIView()
    
    let all = FoodType(name: "All", preview: UIImage(named: "American")!)
    let american = FoodType(name: "American", preview: UIImage(named: "American")!)
    let chinese = FoodType(name: "Chinese", preview: UIImage(named: "Chinese")!)
    let french = FoodType(name: "French", preview: UIImage(named: "French")!)
    let greek = FoodType(name: "Greek", preview: UIImage(named: "Greek")!)
    let indian = FoodType(name: "Indian", preview: UIImage(named: "Indian")!)
    let italian = FoodType(name: "Italian", preview: UIImage(named: "Italian")!)
    let korean = FoodType(name: "Korean", preview: UIImage(named: "Korean")!)
    let mexican = FoodType(name: "Mexican", preview: UIImage(named: "Mexican")!)
    let thai = FoodType(name: "Thai", preview: UIImage(named: "Thai")!)
    let turkish = FoodType(name: "Turkish", preview: UIImage(named: "Turkish")!)
    let vietnamese = FoodType(name: "Vietnamese", preview: UIImage(named: "Vietnamese")!)
    
    var foodCategories: [FoodType] = []
    
    
    // Present the Autocomplete view controller when the button is pressed.
    @IBAction func autocompleteClicked(_ sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        foodCategories = [all, american, chinese, french, greek, indian, italian, korean, mexican, thai, turkish, vietnamese]
        
        theTable.dataSource = self
        theTable.delegate = self
        
        theTable.isHidden = true
        theTable.layer.zPosition = 2
        theTable.separatorStyle = .none
        theTable.rowHeight = 55
        
        theTable.frame = CGRect(x: 0, y: self.view.frame.size.height+64, width: self.view.frame.size.width, height: 0)
        
        theTableHeader.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 64)
        theTableHeader.backgroundColor = UIColor.white
        theTableHeader.layer.shadowOpacity = 0.2
        theTableHeader.layer.shadowRadius = 1.0
        theTableHeader.layer.shadowColor = UIColor.black.cgColor
        theTableHeader.layer.shadowOffset = CGSize(width:0, height:1)
        theTableHeader.layer.zPosition = 3
        
        let tableTitle = UILabel(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 44))
        tableTitle.textColor = UIColor(hexString: "#333333")
        tableTitle.text = "Cuisines"
        tableTitle.textAlignment = .center
        tableTitle.font = tableTitle.font.withSize(18)
        theTableHeader.addSubview(tableTitle)
        
        let the_close_button = UIImageView(frame: CGRect(x: 17, y: 34, width: 17, height: 17))
        the_close_button.contentMode = .scaleAspectFit
        
        let buttonImg = UIImage(named: "closeButton")
        let button   = UIButton(type: UIButtonType.custom) as UIButton
        button.frame = CGRect(x: 17, y: 34, width: 17, height: 17)
        button.setImage(buttonImg, for: .normal)
        button.addTarget(self, action: #selector(ViewController.hideTable(_:)), for:.touchUpInside)
        theTableHeader.addSubview(button)
        
        /*
         foodTypes.frame.size.width = self.view.frame.size.width
         foodTypes.frame.size.height = self.view.frame.size.height
         foodTypes.isHidden = true
         */
        
        let headerbar = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        headerbar.backgroundColor = UIColor.white
        headerbar.layer.shadowOpacity = 0.3
        headerbar.layer.shadowRadius = 2.0
        headerbar.layer.shadowColor = UIColor.black.cgColor
        headerbar.layer.shadowOffset = CGSize(width:0, height:1)
        
        headerbar.layer.zPosition = 1
        
        let logo = UIImage(named: "logoOld")
        let imageView = UIImageView(image:logo)
        imageView.frame.size.width = self.view.frame.size.width-80
        imageView.frame.size.height = 24
        imageView.frame.origin.x = 40
        imageView.frame.origin.y = self.view.frame.size.height/2-12
        imageView.contentMode = .scaleAspectFit
        
        headerbar.addSubview(imageView)
        
        self.view.addSubview(headerbar)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.isNavigationBarHidden = true
        /*
         self.navigationController?.navigationBar.layer.shadowOpacity = 0.3
         self.navigationController?.navigationBar.layer.shadowRadius = 2.0
         self.navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
         self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width:0, height:1)
         
         
         self.navigationItem.titleView = imageView
         */
        
        let devHeight = self.view.frame.size.height-64
        let devWidth = self.view.frame.size.width
        
        print(devHeight)
        
        let buttonWidth = devWidth/2-2
        _ = buttonWidth + 100
        
        //let mapHeight = devHeight - totalHeight
        
        self.view.addSubview(getButtonCont())
        
        self.view.backgroundColor = UIColor(hexString: "#f7f7f7")
        
        self.mapView.frame = CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: devHeight)
        self.mapView.backgroundColor = UIColor.white
        
        let bannerImg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height))
        bannerImg.image = UIImage(named: "banner1")
        bannerImg.contentMode = .scaleAspectFill
        bannerImg.clipsToBounds = true
        
        let blackOverlay = UIView(frame:CGRect(x: 0, y: 0, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height))
        blackOverlay.backgroundColor = UIColor.black
        blackOverlay.layer.opacity = 0.75
        
        let contentCont = UIView(frame: CGRect(x: 0, y: devHeight/2-90, width: devWidth, height: 180))
        
        let titleText1 = UILabel(frame: CGRect(x: 0, y: 120, width: devWidth, height: 40))
        titleText1.text = "Add a Destination"
        titleText1.textColor = UIColor.white
        titleText1.textAlignment = .center
        titleText1.layer.shadowOpacity = 0.3
        titleText1.layer.shadowRadius = 2.0
        titleText1.layer.shadowColor = UIColor.black.cgColor
        titleText1.layer.shadowOffset = CGSize(width:0, height:1)
        titleText1.font = titleText1.font.withSize(24)
        
        let titleText2 = UILabel(frame: CGRect(x: 0, y: 150, width: devWidth, height: 40))
        titleText2.text = "and find a great place to eat!"
        titleText2.textColor = UIColor.white
        titleText2.textAlignment = .center
        titleText2.layer.shadowOpacity = 0.3
        titleText2.layer.shadowRadius = 2.0
        titleText2.layer.shadowColor = UIColor.black.cgColor
        titleText2.layer.shadowOffset = CGSize(width:0, height:1)
        titleText2.font = titleText2.font.withSize(16)
        
        let plusButton = UIImageView(frame: CGRect(x: devWidth/2-40, y: 0, width: 80, height: 80))
        plusButton.image = UIImage(named: "close_button")
        plusButton.contentMode = .scaleAspectFit
        
        contentCont.addSubview(plusButton)
        
        contentCont.addSubview(titleText1)
        contentCont.addSubview(titleText2)
        
        self.mapView.addSubview(bannerImg)
        self.mapView.addSubview(blackOverlay)
        self.mapView.addSubview(contentCont)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.loadPlaces(_:)))
        
        self.mapView.addGestureRecognizer(gesture)
        
        self.view.addSubview(self.mapView)
        
        self.bottomBar.frame = CGRect(x: 0, y: devHeight-70, width: self.view.frame.size.width, height: 70)
        self.bottomBar.backgroundColor = UIColor(hexString: "#333333")
        /*
         self.bottomBar.layer.shadowOpacity = 0.3
         self.bottomBar.layer.shadowRadius = 2.0
         self.bottomBar.layer.shadowColor = UIColor.black.cgColor
         self.bottomBar.layer.shadowOffset = CGSize(width:0, height:1)
         */
        //self.view.addSubview(self.bottomBar)
        
        theTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        UIView.animate(withDuration: 0.3, delay: 2.0, options: [.curveEaseInOut], animations: {
            headerbar.frame.size.height = 64
            imageView.frame.origin.y = 30
        }, completion: nil)
        
    }
    
    func loadPlaces(_ sender: UITapGestureRecognizer) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    func getButtonCont() -> UIView {
        
        foodcontainer.frame = CGRect(x: 0, y: self.view.frame.size.height-64, width: self.view.frame.size.width, height: (self.view.frame.size.height)/2)
        
        button1.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: foodcontainer.frame.size.height)
        button1.image = foodCategories[3].preview
        button1.contentMode = .scaleAspectFill
        button1.clipsToBounds = true
        
        let contentCont = UIView(frame: CGRect(x: 0, y: foodcontainer.frame.size.height/2-90, width: self.view.frame.size.width, height: 180))
        
        titleText1.frame = CGRect(x: 0, y: 120, width: self.view.frame.size.width, height: 40)
        titleText1.text = "Choose a Type of Cuisine"
        titleText1.textColor = UIColor.white
        titleText1.textAlignment = .center
        titleText1.layer.shadowOpacity = 0.3
        titleText1.layer.shadowRadius = 2.0
        titleText1.layer.shadowColor = UIColor.black.cgColor
        titleText1.layer.shadowOffset = CGSize(width:0, height:1)
        titleText1.font = titleText1.font.withSize(24)
        
        titleText2.frame = CGRect(x: 0, y: 150, width: self.view.frame.size.width, height: 40)
        titleText2.text = "to find exactly what you want!"
        titleText2.textColor = UIColor.white
        titleText2.textAlignment = .center
        titleText2.layer.shadowOpacity = 0.3
        titleText2.layer.shadowRadius = 2.0
        titleText2.layer.shadowColor = UIColor.black.cgColor
        titleText2.layer.shadowOffset = CGSize(width:0, height:1)
        titleText2.font = titleText1.font.withSize(16)
        
        plusButton.frame = CGRect(x: self.view.frame.size.width/2-40, y: 0, width: 80, height: 80)
        plusButton.image = UIImage(named: "close_button")
        plusButton.contentMode = .scaleAspectFit
        
        contentCont.addSubview(plusButton)
        
        contentCont.addSubview(titleText1)
        contentCont.addSubview(titleText2)
        
        /*
         
         let label = UILabel(frame: CGRect(x: 0, y: 0, width: button1.frame.size.width, height: button1.frame.size.height))
         label.text = foodCategories[3].name
         label.textColor = UIColor.white
         label.textAlignment = .center
         label.layer.shadowOpacity = 0.3
         label.layer.shadowRadius = 2.0
         label.layer.shadowColor = UIColor.black.cgColor
         label.layer.shadowOffset = CGSize(width:0, height:1)
         label.font = label.font.withSize(28)
         */
        
        let overlay = UIView(frame: CGRect(x: 0, y: 0, width: button1.frame.size.width, height: button1.frame.size.height))
        overlay.backgroundColor = UIColor.black
        overlay.layer.opacity = 0.6
        
        button1.addSubview(overlay)
        button1.addSubview(contentCont)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.loadTypes(_:)))
        //button1.addGestureRecognizer(gesture)
        foodcontainer.addGestureRecognizer(gesture)
        foodcontainer.addSubview(button1)
        
        return foodcontainer
    }
    
    func loadTypes(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.theTableHeader.frame.origin.y = 0
            self.theTable.isHidden = false
            self.theTable.frame.origin.y = 64
            self.theTable.frame.size.height = self.view.frame.size.height-64
        })
    }
    
    func hideTable(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, animations: {
            self.theTableHeader.frame.origin.y = self.view.frame.size.height
            self.theTable.frame.origin.y = self.view.frame.size.height+64
            self.theTable.frame.size.height = self.view.frame.size.height-64
        })
    }
    
    func selectedTable() {
        
        var theB = UIView()
        
        button1.image = foodCategories[onType].preview
        titleText1.removeFromSuperview()
        titleText2.removeFromSuperview()
        plusButton.removeFromSuperview()
        finalTitle.removeFromSuperview()
        
        if isCheckFood == 1 {
            finalTitle.frame = CGRect(x: 0, y: 0, width: button1.frame.size.width, height: button1.frame.size.height-50)
            modernArrow.frame.origin.x = self.view.frame.size.width - 55
        } else {
            finalTitle.frame = CGRect(x: 0, y: 25, width: button1.frame.size.width, height: button1.frame.size.height-50)
            modernArrow.frame.origin.x = self.view.frame.size.width
            let theButton = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 60))
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.continuePage(_:)))
            theButton.addGestureRecognizer(gesture)
            theButton.backgroundColor = UIColor(hexString: "#2abf88")
            let buttonTitle = UILabel(frame: CGRect(x: 40, y: 0, width: self.view.frame.size.width-90, height: theButton.frame.size.height))
            buttonTitle.text = "Find Restuarants"
            buttonTitle.textColor = UIColor.white
            buttonTitle.font = buttonTitle.font.withSize(20)
            theButton.addSubview(buttonTitle)
            modernArrow.frame.size.width = 40
            modernArrow.frame.size.height = 40
            modernArrow.frame.origin.y = 10
            modernArrow.image = UIImage(named: "modernRight")
            modernArrow.contentMode = .scaleAspectFit
            modernArrow.clipsToBounds = true
            theButton.addSubview(self.modernArrow)
            theB = theButton
            self.view.addSubview(theB)
        }
        finalTitle.text = foodCategories[onType].name
        finalTitle.textAlignment = .center
        finalTitle.textColor = UIColor.white
        finalTitle.font = finalTitle.font.withSize(28)
        button1.addSubview(finalTitle)
        UIView.animate(withDuration: 0.3, animations: {
            self.theTableHeader.frame.origin.y = self.view.frame.size.height
            self.theTable.frame.origin.y = self.view.frame.size.height+64
            self.theTable.frame.size.height = self.view.frame.size.height-64
            }, completion: { finish in
                UIView.animate(withDuration: 0.4, animations: {
                    theB.frame.origin.y = self.view.frame.size.height-60
                    self.modernArrow.frame.origin.x = self.view.frame.size.width - 55
                    self.finalTitle.frame.origin.y = 0
                    self.isCheckFood = 1
                })
        })
        
    }
    
    func continuePage(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "showRestaurant", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .checkmark
            self.onType = indexPath.row
            selectedTable()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodCategories.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = foodCategories[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurant" {
            if let destinationVC = segue.destination as? RestaurantViewController {
                destinationVC.typeOfFood = self.foodCategories[onType].name
                destinationVC.latitude = self.goingToLoc.latitude
                destinationVC.longitude = self.goingToLoc.longitude
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .default
    }
}

extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let coordinates: CLLocationCoordinate2D =  place.coordinate
        self.goingToLoc = coordinates
        let long = coordinates.longitude
        let lat = coordinates.latitude
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16)
        let mapView2 = GMSMapView(frame: CGRect(x: self.mapView.frame.origin.x, y: self.mapView.frame.origin.y, width: self.mapView.frame.size.width, height: self.mapView.frame.size.height))
        //was -60 for height
        
        let position = CLLocationCoordinate2DMake(lat, long)
        let marker = GMSMarker(position: position)
        marker.map = mapView2
        
        let overlay = UIView()
        overlay.frame = mapView2.frame
        overlay.backgroundColor = UIColor.black
        overlay.layer.opacity = 0.6
        
        if self.placeLabelHolder != 64 {
            self.placeLabelHolder = overlay.frame.size.height-80
        }
        
        let placeLabel = UILabel(frame: CGRect(x: 20, y: self.placeLabelHolder, width: overlay.frame.size.width-40, height: 80))
        placeLabel.text = place.name
        placeLabel.textAlignment = .center
        placeLabel.textColor = UIColor.white
        placeLabel.layer.shadowOpacity = 0.3
        placeLabel.layer.shadowRadius = 1.0
        placeLabel.layer.shadowColor = UIColor.black.cgColor
        placeLabel.layer.shadowOffset = CGSize(width:0, height:1)
        placeLabel.font = placeLabel.font.withSize(22)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.loadPlaces(_:)))
        
        mapView2.camera = camera
        
        overlay.addGestureRecognizer(gesture)
        
        self.mapView.removeFromSuperview()
        
        self.view.addSubview(mapView2)
        self.view.addSubview(overlay)
        self.view.addSubview(placeLabel)
        self.theTable.removeFromSuperview()
        self.theTableHeader.removeFromSuperview()
        self.dismiss(animated: true, completion: {
            
            UIView.animate(withDuration: 0.3, animations: {
                mapView2.frame.size.height = (self.view.frame.size.height-64)/2
                overlay.frame.size.height = (self.view.frame.size.height-64)/2
                placeLabel.frame.origin.y = 64
                self.placeLabelHolder = 64
                self.mapView.frame.size.height = (self.view.frame.size.height-64)/2
                self.foodcontainer.frame.origin.y = (self.view.frame.size.height-64)/2+64
            })
        })
        self.view.addSubview(self.theTable)
        self.view.addSubview(self.theTableHeader)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
}
