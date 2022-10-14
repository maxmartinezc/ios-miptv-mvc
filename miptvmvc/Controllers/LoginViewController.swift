//
//  ViewController.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 04-03-22.
//

import UIKit

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
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userField: UITextField = {
        let field = UITextField()
        field.placeholder = "User"
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.backgroundColor = .white
        field.autocapitalizationType = .none
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.backgroundColor = .white
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        return field
    }()

    private let userLabelError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Please enter valid email"
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = K.Colors.title
        return label
    }()
    
    private let passwordLabelError: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.text = "Please enter a password of 6 characters"
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = K.Colors.title
        return label
    }()
    
    private let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = K.Colors.button
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        return button
    }()
    
    private let hStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
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
            appLogoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            appLogoImageView.widthAnchor.constraint(equalToConstant: 250),
            appLogoImageView.heightAnchor.constraint(equalToConstant: 250),
            
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: appLogoImageView.bottomAnchor, constant: 15),
            loginLabel.heightAnchor.constraint(equalToConstant: 30),
            
            hStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            hStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            hStackView.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
    
            userField.heightAnchor.constraint(equalToConstant: 50),
            passwordField.heightAnchor.constraint(equalToConstant: 50),
            loginButton.heightAnchor.constraint(equalToConstant: 60),
            userLabelError.heightAnchor.constraint(equalToConstant: 10),
            passwordLabelError.heightAnchor.constraint(equalToConstant: 10)
            
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
            self.view.hideLoading()
            self.delegate?.didUserLogin()
        }
    }
    
    private func didUserLogin() {
        self.delegate?.didUserLogin()
    }
}

//MARK: - LoginManagerDelegate

extension LoginViewController: LoginManagerDelegate {
    func didUpdateLogin(_ loginManager: LoginManager, userData: UserModel) {
        DispatchQueue.main.async {
            self.view.hideLoading()
            Utils.setUserPlayList(url: userData.playListUrl)
            self.didUserLogin()
        }
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
