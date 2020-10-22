//
//  ProfileViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 6/1/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Profile"
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        {
            changeRequest.displayName = "JJJJ"
            changeRequest.commitChanges { (error) in
                if let error = error
                {
                    print("更改displayName失敗，錯誤訊息 ＝", error.localizedDescription)
                }
            }
        }
        if let currentUser = Auth.auth().currentUser?.email
        {
            nameLabel.text = currentUser
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func logout(_ sender: UIButton) {
        do
        {
            try Auth.auth().signOut()
    }catch
    {
        let alert = UIAlertController(title: "登出失敗", message: error.localizedDescription, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(OKAction)
        present(alert, animated: true, completion: nil)
    }
    
        if let welcomeVC = storyboard?.instantiateViewController(withIdentifier: "WelcomeView")
        {
            UIApplication.shared.keyWindow?.rootViewController = welcomeVC
            dismiss(animated: true, completion: nil)
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
