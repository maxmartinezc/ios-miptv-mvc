//
//  FilterView.swift
//  miptvmvc
//
//  Created by Max Martinez Cartagena on 09-10-22.
//

import UIKit

class FilterView: UIView {
    
    private let hStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .center
        stack.backgroundColor = K.Colors.selectedChannelBoxBackground
        return stack
    }()
    
    let favoriteButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = .white
        return button
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let textFieldSearch: UITextField = {
        let text = UITextField()
        let uiImage = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        uiImage.tintColor = .black
        text.backgroundColor = .white
        text.translatesAutoresizingMaskIntoConstraints = false
        text.leftView = uiImage
        text.leftViewMode = .always
        text.placeholder = "Search..."
        text.layer.borderColor = UIColor.black.cgColor
        text.layer.cornerRadius = 5
        text.layer.borderWidth = 1
        
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        hStackView.addArrangedSubview(favoriteButton)
        hStackView.addArrangedSubview(textFieldSearch)
        hStackView.addArrangedSubview(searchButton)
        
        self.backgroundColor = .clear
        addSubview(hStackView)
        
        setupView()
    }
    
    private func setupView() {
        NSLayoutConstraint.activate([

            favoriteButton.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.3),
            textFieldSearch.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.5),
            searchButton.widthAnchor.constraint(equalTo: hStackView.widthAnchor, multiplier: 0.2),
            hStackView.widthAnchor.constraint(equalTo: self.widthAnchor),
//            hStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
//            hStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
