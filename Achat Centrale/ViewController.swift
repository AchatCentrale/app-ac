//
//  ViewController.swift
//  Achat Centrale
//
//  Created by Jean-baptiste on 22/08/2018.
//  Copyright © 2018 Jean-baptiste. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire



class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var inputEmail: UITextField!
    
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBOutlet weak var badPassword: UILabel!
    
    
    @IBAction func btnLogin(_ sender: Any) {
        
        let parameters : [String: AnyObject]  = ["email": self.inputEmail.text as AnyObject , "password": self.inputPassword.text as AnyObject]
        
        let urlLogin = "http://api.achatcentrale.fr/v1/user/login"
        
        
        
        Alamofire.request(urlLogin, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let json = response.result.value {
                
                let data = JSON(json)
                
                print(data)
                if (data["status"] == "ok"){
                    print("Connexion reussie")
                    
                    
                    self.saveLoggedState()
                    
                    let userDefaults = UserDefaults.standard
                    
                    let clientDetails = [ data["details"]["CL_ID"].intValue,data["details"]["SO_ID"].intValue, data["details"]["CC_ID"].intValue  ]
                    
                    userDefaults.set(clientDetails, forKey: "userDetails")
                    
                    self.saveLoggedState()

                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let HomeMessagerieController = storyBoard.instantiateViewController(withIdentifier: "HomeMessagerie") as! HomeMessagerieController
                    
                    self.present(HomeMessagerieController, animated:true, completion:nil)
                    
                } else if (data["status"] == "ko") {
                    
                    // MARK
                    //Mettre message d'erreur
                    
                    
                }
                
            }
            
            
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
        
        
        
        
        inputPassword.isSecureTextEntry = true
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func saveLoggedState() {
        
        let def = UserDefaults.standard
        def.set(true, forKey: "is_authenticated") // save true flag to UserDefaults
        def.synchronize()
        
    }
    
    func logoutState() {
        
        let def = UserDefaults.standard
        def.set(false, forKey: "is_authenticated") // save true flag to UserDefaults
        def.synchronize()
        
    }
    
    
}


