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
   //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        let timestamp = Double(Date().timeIntervalSince1970)
        
       
        //哪一頁要跳轉到Google登入頁
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
        // 讓使用者可以恢復Google登入
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getFirebaseTokenToMainView()

    }
    
    //MARK: - Custom Function
    func toPage(withIdentifier: String)
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: withIdentifier)
        {
            //利用這個方法抽換底層的頁面來避免頁面火車
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

    func getTimestamp() -> String
    {
        // 我們上面 print 出的時間戳
        let timeStamp = Date().timeIntervalSince1970
   
        // 初始化一個 Date
        let date = Date(timeIntervalSince1970: timeStamp)
        // 實例化一個 DateFormatter
        let dateFormatter = DateFormatter()
        // 設定日期格式
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        // 將日期轉換成 string 輸出給 today
        let today = dateFormatter.string(from: date)
        print("Time Stamp's Current Time:\(today)")
        print(NSDate().timeIntervalSince1970,Date().timeIntervalSince1970)
        return today
    }
 
    //MARK: - IBAction
    @IBAction func facebookLogin(_ sender: UIButton) {
        //實例化登入管理類別
        let fbLoginManager = LoginManager()
        
        //呼叫登入的方法，並且在permissions輸入想要的權限，若無特別需求，獲取使用者資料跟email就可以了如果要獲取其他的需要經過Facebook的審核，是這個頁面要登入，所以viewController給self就好，另外閉包內參數的類別是LoginResult，裡面有三個形態，分別是.failed,.success,.cancel
      
        fbLoginManager.logIn(permissions: [.publicProfile,.email], viewController: self) { (result) in
            //開始讀取動畫
            self.startLoading(self.view)
            
            //針對不同的case進行後續處理，這邊先針對.success就好
            switch result
            {
            case .failed(let error):
                print(error.localizedDescription)
                self.stopLoading()
                
                //由於我只用得到token，所以其他兩個關聯值我都省略
            case .success(granted: _, declined: _, token: let token):

                //這是證書的概念，使用Firebase的類別，並且使用token產生一個證書
                let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
                //Firebase利用剛剛產生的證書進行登入
                Auth.auth().signIn(with: credential) { (result, error) in
                    if let error = error
                    {
                        self.stopLoading()
                        let alert = UIAlertController(title: "登入失敗", message: error.localizedDescription, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    //登入成功，沒有產生任何error，則呼叫這個方法跳轉到下個頁面
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
        startLoading(self.view)
        GIDSignIn.sharedInstance()?.signIn()
        
    }
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue)
    {
        
    }
}

// MARK: - Extension
extension WelcomeViewController: GIDSignInDelegate
{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        self.stopLoading()
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
