//
//  HomeViewController.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 18-03-22.
//

import UIKit

protocol HomeViewControlerDelegate: AnyObject {
    func didTapMenuButton(menu: HomeViewController.MenuOptions)
}

class HomeViewController: UIViewController {
    
    weak var delegate: HomeViewControlerDelegate?
   
    enum MenuOptions: String, CaseIterable {
        case about = "About"
        case logout = "Logout"
        
        var imageName: String {
            switch self {
            case .logout:
                return "escape"
            case .about:
                return "star"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.setNavigationBarHidden(false, animated: false)
        setupMenu()
    }
    
    private func setupMenu() {
        var menuItems = [UIAction]()
        
        for item in MenuOptions.allCases {
            menuItems.append(
                UIAction(title: item.rawValue, image: UIImage(systemName: item.imageName)) { (action) in
                    self.didTapMenuButton(menu: item)
                }
            )
        }

        let menu = UIMenu(image: UIImage(systemName: "person"), children: menuItems)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), menu: menu)
    }
    
    private func didTapMenuButton(menu: MenuOptions) {
        DispatchQueue.main.async {
            self.delegate?.didTapMenuButton(menu: menu)
        }
    }
}
