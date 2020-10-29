//
//  WelcomeViewController.swift
//  FirebaseDemo
//
//  Created by Simon Ng on 5/1/2017.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
class WelcomeViewController: UIViewController, LoadAnimationAble
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        


        
        
        self.title = ""
        
        //哪一頁要跳轉到Google登入頁
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        // 讓使用者可以恢復Google登入
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getFirebaseTokenToMainView()

    }
    func toPage(withIdentifier: String)
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: withIdentifier)
        {
            UIApplication.shared.windows.first?.rootViewController = vc
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    func getFirebaseTokenToMainView() {
        if let currentUser = Auth.auth().currentUser
        {
            print("目前使用者登入的帳號為：",whichLoginMethod(currentUser.providerData[0].providerID))
            
            toPage(withIdentifier: "MainView")
        }
    }
    func getFBTokenToMainView()
    {
        if AccessToken.current != nil {
            toPage(withIdentifier: "MainView")
        } else {
            print("目前無使用者資料")
        }
    }
    func whichLoginMethod(_ loginMethod: String) -> String
    {
        var method: String
        {
            switch loginMethod {
            case "facebook.com":
                return "Facebook"
            case "google.com":
                return "Google"
            default:
                return "Firebase"
            }
        }
        return method
    }

  
 
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: [.publicProfile,.email], viewController: self) { (result) in
            self.startLoading(self)
            switch result
            {
            case .failed(let error):
                print(error.localizedDescription)
                self.stopLoading()
            case .success(granted: _, declined: _, token: let token):

                let creditcal = FacebookAuthProvider.credential(withAccessToken: token.tokenString)

                Auth.auth().signIn(with: creditcal) { (result, error) in
                    if let error = error
                    {
                        print("登入發生錯誤 = ",error.localizedDescription)
                        return
                    }

                    self.toPage(withIdentifier: "MainView")



                    print("登入成功")
                }

            case .cancelled:
                self.stopLoading()
                print("登入Cancelled")
            }
        }

    }
    
    @IBAction func googleLogin(_ sender: UIButton) {
        startLoading(self)
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue)
    {
        
    }
}
extension WelcomeViewController: GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
      if let error = error {
        if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
          print("使用者尚未登入Google或者已經登出")
        }
        return
      }
      
      
        guard let authentication = user.authentication else{return}
        let credentical = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credentical) { (result , error) in
            if let error = error
            {
                print("使用Google的credentical登錄到Firebase時發生錯誤")
                return
            }
            
            print("########成功登入Google########")
            self.toPage(withIdentifier: "MainView")

        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // ...
        
        print("＊＊＊＊＊登入Google失敗＊＊＊＊＊＊")
    }
}
