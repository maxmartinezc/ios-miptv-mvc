//
//  PopUpController.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 04-10-22.
//

import UIKit
enum AlertTypes: String {
    case error
    case info
    case warning
}

class PopUpViewController: UIViewController {
    private let alertType: AlertTypes
    private let alertTitle: String?
    private let alertMessage: String
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = K.Colors.alertContentBackground
        view.layer.cornerRadius = K.Popup.viewCornerRadius
        view.layer.borderWidth = K.Popup.viewBorderWidth
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = K.Colors.alertTitle
        label.font = K.Popup.labelTitleFont
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = K.Colors.alertMessage
        label.font = K.Popup.labelMessageFont
        label.translatesAutoresizingMaskIntoConstraints = false
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = K.Popup.labelMessageNumberOfLines
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = K.Colors.button
        button.layer.cornerRadius = K.Popup.buttonCornerRadius
        button.layer.borderWidth = K.Popup.buttonBorderWidth
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = K.Colors.alertBackground
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
        UIView.animate(withDuration: K.Popup.animationDuration, animations: {
            self.contentView.transform = .identity
        })
    }
    
    func setupView() {
        NSLayoutConstraint.activate([
            
            contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: K.Popup.contentViewWidthAnchor),
            contentView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: K.Popup.contentViewBottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.Popup.titleLabelTopAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: K.Popup.messageLabelTopAnchor),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: K.Popup.buttonTopAnchor),
            button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: K.Popup.buttonWidthAnchor)
        ])
    }
    
    @objc private func buttonPressed() {
        self.contentView.transform = .identity
        UIView.animate(withDuration: K.Popup.animationDuration, animations: {
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }) { (complete) in
            self.view.removeFromSuperview()
        }
    }
}
