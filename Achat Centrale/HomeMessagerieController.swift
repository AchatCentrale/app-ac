//
//  HomeMessagerieController.swift
//  Achat Centrale
//
//  Created by Jean-baptiste on 23/08/2018.
//  Copyright © 2018 Jean-baptiste. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage


let userDefaults = UserDefaults.standard

class HomeMessagerieController: UIViewController {
    
    
    
    @IBOutlet weak var profilPic: UIImageView!
    

    @IBOutlet weak var viewHeader: UIView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var raisonSoc: UILabel!
    
    
    @IBAction func logoutAction(_ sender: Any) {
        self.logoutState()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "loginST")
        
        self.present(vc, animated: true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
      
        viewHeader.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        viewHeader.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        viewHeader.layer.shadowOpacity = 0.5
        viewHeader.layer.shadowRadius = 0.0
        viewHeader.layer.masksToBounds = false
        
       
        let userDetails = userDefaults.object(forKey: "userDetails") as? [Int] ?? [Int]()
        
        print(userDetails)
        self.loadUserDetail(client_id: userDetails[0], centrale_id: userDetails[1], user_id: userDetails[2])
   
    }
    
    
    func loadUserDetail(client_id: Int, centrale_id: Int,  user_id: Int){
        Alamofire.request("http://api.achatcentrale.fr/v1/client/details/\(centrale_id)/\(client_id)/\(user_id)").responseJSON { response in
            if let json = response.result.value {
                let data = JSON(json)
                print(data)
                self.raisonSoc.text = data["data"]["CL_RAISONSOC"].string
                self.userName.text =  "\(data["data"]["CC_PRENOM"].stringValue) \(data["data"]["CC_NOM"].stringValue)"
                
                self.loadProfilePic(image_url: data["logo"].stringValue)
           }
        }
    }
    
    func loadProfilePic(image_url: String) -> Void{
        
        Alamofire.request(image_url).responseImage { response in
            if let image = response.result.value {
                self.profilPic.image = image
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
