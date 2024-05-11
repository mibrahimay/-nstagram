//
//  SignupViewController.swift
//  Filling
//
//  Created by mac on 17.02.2024.
//

import UIKit

class SignupViewController: UIViewController {
    struct Constants {
        static let cornerRadius : CGFloat = 8.0
    }
    private let usernameField : UITextField = {
        let field = UITextField()
        field.placeholder = "username"
        field.returnKeyType = .next
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0 , width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        return field
    }()
    private let emailField : UITextField = {
        let field  = UITextField()
        field.isSecureTextEntry = false
        field.placeholder = "email adress"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0 , width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()
    
    private let passwordField : UITextField = {
        let field  = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "password"
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0 , width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()
    private let signupButton : UIButton = {
        let button =  UIButton()
        button.setTitle("Sign Up !", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signupButton)
        signupButton.addTarget(self, action: #selector(didTabSignUp), for: .touchUpInside)
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        view.backgroundColor = .systemPink
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        usernameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top+100, width: view.width-40, height: 52)
        emailField.frame = CGRect(x: 20, y: usernameField.bottom+10, width: view.width-40, height: 52)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 52)
        signupButton.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 52)
        
    }
    @objc func didTabSignUp(){
        passwordField.resignFirstResponder()
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, password.count >= 8,
              let username = usernameField.text, !username.isEmpty else {
            return
        }
        AuthManager.shared.signupNewUser(username: username, email: email, password: password){ signedUp in
            DispatchQueue.main.async{
                if signedUp {
                    //good to go
                }else {
                    //failed
                }
            }
        }
    }
}
extension SignupViewController: UITextFieldDelegate{
    func textFieldShouldReturn ( _ textField : UITextField) -> Bool {
            if textField == usernameField {
                emailField.becomeFirstResponder()
            }
            else if textField == emailField {
                passwordField.becomeFirstResponder()
            }
            else {
                didTabSignUp()
            }
            return true
        }
    }

