//
//  ViewController.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 04-03-22.
//

import UIKit
import FirebaseAnalytics

protocol LoginViewControllerDelegate: AnyObject {
    func didUserLogin()
}

class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    var loginManager = LoginManager()
    
    let appLogoImageView: UIImageView = {
        let image = UIImage(named: K.appLogo)
        let uiImageView = UIImageView(image: image!)
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        return uiImageView
    }()
    
    private let loginLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Sign in"
        label.textColor = K.Colors.title
        label.font = K.Login.labelTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userField: UITextField = {
        let field = UITextField()
        field.placeholder = "User"
        field.textColor = K.Colors.textFieldTextColor
        field.layer.borderColor = K.Colors.textFieldBorderColor
        field.backgroundColor = K.Colors.textFieldBackgroundColor
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: K.Login.textFieldLeftViewX, y: K.Login.textFieldLeftViewY, width: K.Login.textFieldLeftViewWidth, height: K.Login.textFieldLeftViewHeight))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = K.Login.textFieldCornerRadius
        field.layer.borderWidth = K.Login.textFieldBorderWidth
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.textColor = K.Colors.textFieldTextColor
        field.layer.borderColor = K.Colors.textFieldBorderColor
        field.backgroundColor = K.Colors.textFieldBackgroundColor
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: K.Login.textFieldLeftViewX, y: K.Login.textFieldLeftViewY, width: K.Login.textFieldLeftViewWidth, height: K.Login.textFieldLeftViewHeight))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = K.Login.textFieldCornerRadius
        field.layer.borderWidth = K.Login.textFieldBorderWidth
        return field
    }()
    
    private let userLabelError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Please enter valid email"
        label.font = K.Login.labelErrorFont
        label.textColor = K.Colors.title
        return label
    }()
    
    private let passwordLabelError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Please enter a password of 6 characters"
        label.font = K.Login.labelErrorFont
        label.textColor = K.Colors.title
        return label
    }()
    
    private let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = K.Colors.button
        button.layer.cornerRadius = K.Login.buttonCornerRadius
        button.layer.borderWidth = K.Login.buttonBorderWidth
        return button
    }()
    
    private let hStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = K.Login.hStackSpacing
        stack.distribution = .fillProportionally
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loginManager.delegate = self
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        view.backgroundColor = K.Colors.background
        view.addSubview(appLogoImageView)
        view.addSubview(loginLabel)
        
        hStackView.addArrangedSubview(userField)
        hStackView.addArrangedSubview(userLabelError)
        hStackView.addArrangedSubview(passwordField)
        hStackView.addArrangedSubview(passwordLabelError)
        hStackView.addArrangedSubview(loginButton)
        
        view.addSubview(hStackView)
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.userField.text = ""
        self.passwordField.text = ""
        if self.isUserLogged() {
            self.skipLogin()
        }
    }
    
    private func setupView() {
        
        NSLayoutConstraint.activate([
            appLogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: K.Login.appLogoImageViewTopAnchor),
            appLogoImageView.widthAnchor.constraint(equalToConstant: K.Login.appLogoImageViewWidthAnchor),
            appLogoImageView.heightAnchor.constraint(equalToConstant: K.Login.appLogoImageViewHeightAnchor),
            
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: appLogoImageView.bottomAnchor, constant: K.Login.loginLabelTopAnchor),
            loginLabel.heightAnchor.constraint(equalToConstant: K.Login.loginLabelHeightAnchor),
            
            hStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: K.Login.hStackViewLeadingAnchor),
            hStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: K.Login.hStackViewTrailingAnchor),
            hStackView.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: K.Login.hStackViewTopAnchor),
            
            userField.heightAnchor.constraint(equalToConstant: K.Login.userFieldHeightAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: K.Login.passwordFieldHeightAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: K.Login.loginButtonHeightAnchor),
            userLabelError.heightAnchor.constraint(equalToConstant: K.Login.userLabelErrorHeightAnchor),
            passwordLabelError.heightAnchor.constraint(equalToConstant: K.Login.passwordLabelErrorHeightAnchor)
            
        ])
    }
    
    @objc private func loginButtonPressed(){
        
        let user = userField.text!
        let password = passwordField.text!
        
        let isValidEmail = Utils.validateEmail(email: user)
        let isValidPassword = Utils.validatePassword(password: password)
        
        self.passwordLabelError.isHidden = true
        self.userLabelError.isHidden = true
        
        if !isValidEmail {
            self.userLabelError.isHidden = false
        }
        
        if !isValidPassword {
            self.passwordLabelError.isHidden = false
        }
        
        if(isValidEmail && isValidPassword) {
            
            self.view.showLoading()
            
            loginManager.login(user: user, password: password)
        }
    }
    
    private func isUserLogged() -> Bool {
        return Utils.getUserPlayList() != nil ? true : false
    }
    
    private func skipLogin() {
        view.showLoading()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Analytics.logEvent(K.TagManager.SignIn.varName, parameters: [
                K.TagManager.CommonEventParameter.username: Utils.getUsername()!
            ])
            self.view.hideLoading()
            self.delegate?.didUserLogin()
        }
    }
    
    private func didUserLogin(userData: UserModel) {
        DispatchQueue.main.async {
            let username = self.userField.text!
            Analytics.logEvent(K.TagManager.SignIn.varName, parameters: [
                K.TagManager.CommonEventParameter.username: username
            ])
            
            Utils.setUserPlayList(url: userData.playListUrl)
            Utils.setUsername(username: username)
            
            self.view.hideLoading()
            self.delegate?.didUserLogin()
        }
    }
}

//MARK: - LoginManagerDelegate

extension LoginViewController: LoginManagerDelegate {
    func didUpdateLogin(_ loginManager: LoginManager, userData: UserModel) {
        self.didUserLogin(userData: userData)
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.view.hideLoading()
            let popUpController = PopUpViewController(message: error.localizedDescription, type: .error, title: nil)
            self.addChild(popUpController)
            self.view.addSubview(popUpController.view)
            popUpController.didMove(toParent: self)
        }
    }
}
