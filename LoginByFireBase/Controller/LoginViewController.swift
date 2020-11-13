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
import SnapKit
class LoginViewController: UIViewController {
    private let loginView = LoginView()
    override func loadView() {
        view = loginView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.scrollViewByKeyboard()
         loginViewAddEvent()
        print("一開始進來的currentUser = ", Auth.auth().currentUser?.email)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Log In"
//        loginView.accountTF.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = ""
    }
   
    // MARK: Custom Function
    @objc func loginBtnAction(_ sender: UIButton)
    {
//
//        guard let account = loginView.accountTF.text, account != "", let password = loginView.passwordTF.text, password != ""
//        else
//        {
//            let alert = UIAlertController(title: "登入失敗", message: "帳密錯誤", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alert.addAction(okAction)
//            present(alert, animated: true, completion: nil)
//            return
//        }
//
//        Auth.auth().signIn(withEmail: account, password: password) { (user, error) in
//            if let error = error
//            {
//                let alert = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//            }
//            self.view.endEditing(true)
////            if Auth.auth().currentUser?.isEmailVerified
//            print("按下登入的currentUser = ", Auth.auth().currentUser?.email)
//            if user?.user.isEmailVerified == true
//            {
//                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainView")
//                {
////                    UIApplication.shared.keyWindow?.rootViewController = vc
//                                    UIApplication.shared.windows.first?.rootViewController = vc
//                    self.dismiss(animated: true, completion: nil)
////                                    self.present(vc, animated: true, completion: nil)
//
//                }
//            }else
//            {
//
//
//                let alert = UIAlertController(title: "登入失敗", message: "必須驗證信箱後才能登入", preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//
//            }
//
//        }
        
    }
    
    @objc func textFieldChangeValue(sender: CustomTextField)
    {
        if loginView.accountTF.text != "",loginView.passwordTF.text != ""
        {
            loginView.loginBtn.backgroundColor = UIColor.link
            loginView.loginBtn.isEnabled = true
        }else
        {
            loginView.loginBtn.backgroundColor = UIColor.link.withAlphaComponent(0.5  )
            loginView.loginBtn.isEnabled = false
        }
    }
    func presentToHomePage()
    {
        
    }
    
    func loginViewAddEvent()
    {
        
        loginView.accountTF.addTarget(self, action: #selector(textFieldChangeValue(sender:)), for: .editingChanged)
        loginView.passwordTF.addTarget(self, action: #selector(textFieldChangeValue(sender:)), for: .editingChanged)
        loginView.loginBtn.addTarget(self, action: #selector(loginBtnAction(_:)), for: .touchUpInside)
    }
    
    
    deinit {
            print("我被釋放啦！！")
    }
    
    
}
