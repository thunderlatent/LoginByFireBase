//
//  LogonViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 14/12/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
class LoginViewController: UIViewController {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("一開始進來的currentUser = ", Auth.auth().currentUser?.email)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Log In"
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = ""
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func login(_ sender: UIButton)
    {
        
        guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != ""
        else
        {
            let alert = UIAlertController(title: "登入失敗", message: "帳密錯誤", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error
            {
                let alert = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            self.view.endEditing(true)
//            if Auth.auth().currentUser?.isEmailVerified
            print("按下登入的currentUser = ", Auth.auth().currentUser?.email)
            if user?.user.isEmailVerified == true
            {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainView")
                {
//                    UIApplication.shared.keyWindow?.rootViewController = vc
                                    UIApplication.shared.windows.first?.rootViewController = vc
                    self.dismiss(animated: true, completion: nil)
//                                    self.present(vc, animated: true, completion: nil)
                    
                }
            }else
            {
                
                
                let alert = UIAlertController(title: "登入失敗", message: "必須驗證信箱後才能登入", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
    }
    
    
    
    deinit {
            print("我被釋放啦！！")
    }
    
    
}
