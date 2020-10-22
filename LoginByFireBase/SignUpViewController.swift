//
//  SignUpViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 5/1/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class SignUpViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LinBai's Email = ",Auth.auth().currentUser?.email ?? "***NO Value***")
        self.title = "Sign Up"
        nameTextField.becomeFirstResponder()
    }
    
    
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        self.navigationController?.setNavigationBarHidden(false, animated: true)
    //    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        self.navigationController?.setNavigationBarHidden(true, animated: true)
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func registerAccount(_ sender: UIButton) {
         guard let name = nameTextField.text, name != "",
                let emailAddress = emailTextField.text, emailAddress != "",
                let password = passwordTextField.text, password != "" else {
            let alertController = UIAlertController(title: "註冊錯誤", message: "確認所有欄位填寫正確", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(OKAction)
            present(alertController, animated: true, completion: nil)
            return
         }
//        Auth.auth().createUser(withEmail: <#T##String#>, password: <#T##String#>, completion: <#T##AuthDataResultCallback?##AuthDataResultCallback?##(AuthDataResult?, Error?) -> Void#>)
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (user, error) in
            if let error = error
            {
                let alertController = UIAlertController(title: "註冊錯誤", message: error.localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if let changeRequest = user?.user.createProfileChangeRequest()

            {
                changeRequest.displayName = name
                changeRequest.commitChanges { (error) in
                    if let error = error
                    {
                        print("更改displayName失敗，錯誤訊息 ＝", error.localizedDescription)
                    }
                }
            }
            
            
            self.view.endEditing(true)
            user?.user.sendEmailVerification(completion: { (error) in
                print("寄出驗證信")
            })
//            Auth.auth().currentUser?.sendEmailVerification(completion: nil)
            let alertController = UIAlertController(title: "註冊成功", message: "請至信箱確認驗證信", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
            
             
            
        }
        
        
    }
}
