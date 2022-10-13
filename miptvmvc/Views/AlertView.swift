//
//  ErrorAlertView.swift
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

class AlertView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = K.Colors.title
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = K.Colors.title
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let button : UIButton = {
        let button = UIButton()
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
        stack.backgroundColor = K.Colors.alertBackground
//        stack.distribution = .fillProportionally
        stack.layer.borderWidth = 1
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = K.Colors.alertBackground.withAlphaComponent(0.6)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        hStackView.addArrangedSubview(messageLabel)
        hStackView.addArrangedSubview(titleLabel)
        hStackView.addArrangedSubview(button)
        addSubview(hStackView)
        setupView()
    }
    
    private func setupView() {
        NSLayoutConstraint.activate([
            
            hStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            hStackView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -20),
            hStackView.heightAnchor.constraint(equalToConstant: messageLabel.frame.size.height + messageLabel.frame.origin.y + 30),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeAlert(message: String, type: AlertTypes){
        let title: String;
        switch type {
        case .warning:
            title = "Advertencia"
        case .error:
            title = "Oops!"
        default:
            title = "Info"
        }
        self.titleLabel.text = title
        self.button.setTitle("OK", for: .normal)
    }
    
    @objc private func buttonPressed() {
        self.transform = .identity
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        }) { (complete) in
            self.removeFromSuperview()
        }
    }
}

extension UIView {
    func showsAlert(message: String, type: AlertTypes) {
        let alertView = AlertView(frame: frame)
        alertView.makeAlert(message: message, type: type)
        self.addSubview(alertView)
        alertView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        UIView.animate(withDuration: 0.25, animations: {
            alertView.transform = .identity
        })
    }
}
