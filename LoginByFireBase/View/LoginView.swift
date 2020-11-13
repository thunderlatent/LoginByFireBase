//
//  LoginView.swift
//  SnapKitDemo
//
//  Created by Jimmy on 2020/11/10.
//

import UIKit
import SnapKit

class LoginView: UIView{
    let logImageView = UIImageView()
    let accountTF = CustomTextField()
    let passwordTF = CustomTextField()
    let forgetPasswordBtn = UIButton()
    let loginBtn = UIButton()
    let divideLine = UIView()
    let orLabel = UILabel()
    let fbLoginBtn = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAllUserInterface()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing(true)
    }
    func setupAllUserInterface()
    {
        self.backgroundColor = .systemBackground
        setupLogImageView()
        setupAccountTF()
        setupPasswordTF()
        setupForgetPasswordBtn()
        setupLoginBtn()
        setupdivideLine()
        setupOrLabel()
        setupFBLoginBtn()
        
    }
    func setupLogImageView()
    {
        self.addSubview(logImageView)
        let image = UIImage(named: "Instagram")
        logImageView.tintColor = .black
        logImageView.image = image
        logImageView.contentMode = .scaleAspectFill
        
        logImageView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview().inset(UIScreen.main.bounds.width * 0.3)
            
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.height.equalToSuperview().multipliedBy(0.08)
        }
    }
    
    func setupAccountTF()
    {
        self.addSubview(accountTF)
        accountTF.text = "gel29512@eoopy.com"
        accountTF.placeholder = "電話號碼、用戶名稱或電子郵件"
        accountTF.clearButtonMode = .always
//        let clearButton = UIButton(type: .custom)
//        clearButton.setImage(UIImage(named: "facebook"), for: .normal)
//        clearButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 30)
//        clearButton.addTarget(self, action: #selector(clear(_:)), for: .touchUpInside)
        
//        accountTF.rightView = clearButton
        accountTF.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().multipliedBy(0.675)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
    }
    
    @objc func clear(_ sender : AnyObject) {
        accountTF.text = ""
    }
    func setupPasswordTF()
    {
        self.addSubview(passwordTF)
        passwordTF.text = "gel29512"
        passwordTF.placeholder = "密碼"
        accountTF.clearButtonMode = .always

        passwordTF.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview().multipliedBy(0.815)
            make.top.equalTo(accountTF.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
    func setupForgetPasswordBtn()
    {
        self.addSubview(forgetPasswordBtn)
        forgetPasswordBtn.titleLabel?.contentMode = .scaleAspectFit
        forgetPasswordBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        forgetPasswordBtn.titleLabel?.font = UIFont.systemFont(ofSize: 60)
        forgetPasswordBtn.setTitle("忘記密碼 ?", for: .normal)
        forgetPasswordBtn.setTitleColor(.link, for: .normal)
        forgetPasswordBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(20)
            make.left.greaterThanOrEqualToSuperview()
            make.width.equalTo(forgetPasswordBtn.snp.height).multipliedBy(3)
            
            make.height.equalToSuperview().multipliedBy(0.025)
            make.centerY.equalToSuperview().multipliedBy(0.92)
        }
    }
    
    func setupLoginBtn()
    {
        self.addSubview(loginBtn)
        loginBtn.isEnabled = false
        loginBtn.setTitle("登入", for: .normal)
        loginBtn.setTitleColor(.white, for: .normal)
        loginBtn.backgroundColor = UIColor.link.withAlphaComponent(0.5)
        loginBtn.layer.cornerRadius = 5
        loginBtn.layer.masksToBounds = true
        loginBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview().multipliedBy(1.05)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
    }
    
    func setupdivideLine()
    {
        self.addSubview(divideLine)
        divideLine.addSubview(orLabel)
        divideLine.bounds.size = CGSize(width: UIScreen.main.bounds.width, height: 20)
        divideLine.backgroundColor = .gray
        divideLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(loginBtn.snp.bottom).offset(40)
            make.height.equalTo(2)
        }
    }
    
    func setupOrLabel()
    {
        divideLine.addSubview(orLabel)
        orLabel.backgroundColor = self.backgroundColor
        orLabel.textAlignment = .center
        orLabel.text = "或"
        orLabel.textColor = .black
        orLabel.snp.makeConstraints { (make) in
            make.height.equalTo(loginBtn)
            make.width.equalToSuperview().multipliedBy(0.125)
            make.center.equalToSuperview()
            
        }
    }
    
    func setupFBLoginBtn()
    {
        self.addSubview(fbLoginBtn)
        fbLoginBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        fbLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        fbLoginBtn.setImage(UIImage(named: "facebook"), for: .normal)
        fbLoginBtn.setTitleColor(UIColor(red: 0, green: 140 / 255, blue: 250 / 255, alpha: 1), for: .normal)
        fbLoginBtn.setTitle("繼續使用帳號", for: .normal)
        fbLoginBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        fbLoginBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        fbLoginBtn.snp.makeConstraints { (make) in
            
            make.centerX.equalToSuperview()
            make.top.equalTo(orLabel.snp.bottom).offset(35)
            make.height.equalToSuperview().multipliedBy(0.02)
            make.width.equalTo(fbLoginBtn.snp.height).multipliedBy(7)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



