//
//  LoginVC.swift
//  uteber-developement
//
//  Created by Stu on 25/5/19.
//  Copyright © 2019 UTEBer. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, Alertable {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var authBtn: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    @objc func handleScreenTap(sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }

    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func authBtnWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField != nil {
            self.view.endEditing(true)
            
            if let email = emailField.text, let password = passwordField.text {
                
                Auth.auth().signIn(withEmail: email, password: password, completion: { (authData, error) in
                    if error == nil{
                        if let user = authData?.user {
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                let userData = ["provider": user.providerID] as [String: Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                            } else {
                                let userData = ["provider": user.providerID, USER_IS_DRIVER: true, ACCOUNT_PICKUP_MODE_ENABLED: false, DRIVER_IS_ON_TRIP: false] as [String: Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        
                        if let errorCode = AuthErrorCode(rawValue: error!._code){
                            switch errorCode {
                            case .wrongPassword:
                                self.showAlert(ERROR_MSG_WRONG_PASSWORD)
                            default:
                                self.showAlert(ERROR_MSG_UNEXPECTED_ERROR)
                            }
                        }
                        
                        
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (authData, error) in
                            if error != nil {
                                if let errorCode = AuthErrorCode(rawValue: error!._code){
                                    switch errorCode {
                                    case .invalidEmail:
                                        self.showAlert(ERROR_MSG_INVALID_EMAIL)
                                    default:
                                        self.showAlert(ERROR_MSG_UNEXPECTED_ERROR)
                                    }
                                }
                            } else {
                                if let user = authData?.user {
                                    if self.segmentedControl.selectedSegmentIndex == 0 {
                                        let userData = ["provider": user.providerID] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                                    } else {
                                        let userData = ["provider": user.providerID, USER_IS_DRIVER: true, ACCOUNT_PICKUP_MODE_ENABLED: false, DRIVER_IS_ON_TRIP: false] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                    }
                                }
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
    }
}
