//
//  PopUpController.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 04-10-22.
//

import UIKit
class PopUpViewController: UIViewController {
    private let alertType: AlertTypes
    private let alertTitle: String?
    private let alertMessage: String
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.Colors.alertContentBackground
        view.layer.cornerRadius = 12
        view.layer.borderWidth = 1
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = K.Colors.alertTitle
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = K.Colors.alertMessage
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = K.Colors.button
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = K.Colors.alertBackground.withAlphaComponent(0.8)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(button)
        view.addSubview(contentView)
        makeAlert()
        setupView()
        setAnimation()
    }
    
    init(message: String, type: AlertTypes, title: String?) {
        self.alertMessage = message
        self.alertType = type
        self.alertTitle = title;
           super.init(nibName: nil, bundle: nil)
       }

       required convenience init?(coder: NSCoder) {
           self.init(message: "", type: .info, title: nil)
       }
    
    func makeAlert(){
        let title: String;
        switch self.alertType {
        case .warning:
            title = "Advertencia"
        case .error:
            title = "Oops!"
        default:
            title = "Info"
        }
        self.titleLabel.text = self.alertTitle ?? title
        self.messageLabel.text = self.alertMessage
        self.button.setTitle("OK", for: .normal)
    }
    
    func setAnimation() {
        self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.transform = .identity
        })
    }
    
    func setupView() {
        NSLayoutConstraint.activate([
            
            contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: 50),
            contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 50),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func buttonPressed() {
        self.contentView.transform = .identity
        UIView.animate(withDuration: 0.25, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { (complete) in
            self.view.removeFromSuperview()
        }
    }
}
