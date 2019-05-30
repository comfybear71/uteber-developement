//
//  LeftSidePanelVC.swift
//  uteber-developement
//
//  Created by Stu on 25/5/19.
//  Copyright © 2019 UTEBer. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()
    
    let currentUserID = Auth.auth().currentUser?.uid

    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userAccountTypeLbl: UILabel!
    @IBOutlet weak var userImageView: RoundImageView!
    @IBOutlet weak var loginOutBtn: UIButton!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    @IBOutlet weak var pickupModeLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickupModeSwitch.isOn = false
        pickupModeLbl.isHidden = true
        pickupModeSwitch.isHidden = true
        
        observePassangersAndDrivers()
        
        if Auth.auth().currentUser == nil {
            userEmailLbl.text = ""
            userAccountTypeLbl.text = ""
            userImageView.isHidden = true
            loginOutBtn.setTitle(MSG_SIGN_UP_SIGN_IN, for: .normal)
        } else {
            userEmailLbl.text = Auth.auth().currentUser?.email
            userAccountTypeLbl.text = ""
            userImageView.isHidden = false
            loginOutBtn.setTitle(MSG_SIGN_OUT, for: .normal)
        }
    }
    
    func observePassangersAndDrivers(){
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLbl.text = ACCOUNT_TYPE_PASSENGER
                    }
                }
            }
        })
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLbl.text = ACCOUNT_TYPE_DRIVER
                        self.pickupModeSwitch.isHidden = false
                        
                       // let switchStatus = snap.childSnapshot(forPath: ACCOUNT_PICKUP_MODE_ENABLED).value as! Bool
                        //self.pickupModeSwitch.isOn = switchStatus
                        self.pickupModeLbl.isHidden = false
                    }
                }
            }
        })
    }
    
    @IBAction func switchWasToggled(_ sender: Any) {
        if pickupModeSwitch.isOn {
            pickupModeLbl.text = MSG_PICKUP_MODE_ENABLED
            appDelegate.menuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserID!).updateChildValues([ACCOUNT_PICKUP_MODE_ENABLED: true])
        } else {
            pickupModeLbl.text = MSG_PICKUP_MODE_DISABLED
            appDelegate.menuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserID!).updateChildValues([ACCOUNT_PICKUP_MODE_ENABLED: false])
        }
    }
    
    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: MAIN_STORYBOARD, bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: VC_LOGIN) as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        } else {
            do {
                try Auth.auth().signOut()
                userEmailLbl.text = ""
                userAccountTypeLbl.text = ""
                userImageView.isHidden = true
                pickupModeLbl.text = ""
                pickupModeSwitch.isHidden = true
                loginOutBtn.setTitle(MSG_SIGN_UP_SIGN_IN, for: .normal)
            } catch (let error) {
                print (error)
            }
        }
    }
}