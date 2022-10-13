//
//  ContainerViewController.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 18-03-22.
//

import UIKit

class ContainerViewController: UIViewController {
    
    var navVC: UINavigationController?
    
    let homeVC = HomeViewController()
    
    lazy var playerVC = PlayerViewController()
    lazy var logoutVC = LogoutViewController()
    lazy var loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        homeVC.delegate = self
        loginVC.delegate = self
        logoutVC.delegate = self

        let navVC = UINavigationController(rootViewController: homeVC)
        
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        
        self.navVC = navVC
        
        self.addVC(vc: loginVC)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.lockOrientation(.portrait, andRotateTo: .portraitUpsideDown)
    }

    private func showMenuView(menuItem: HomeViewController.MenuOptions){
        switch menuItem {
        case .logout:
            self.addVC(vc: logoutVC)
            break
        case .about:
            self.about()
        }
    }
    
    func about() {
        let popUpController = PopUpViewController(message: "Developed by \(K.appDeveloper.name) \nContact: \(K.appDeveloper.email) \nLinkedin: \(K.appDeveloper.linkedin)", type: .info, title: "About")
        self.addChild(popUpController)
        self.view.addSubview(popUpController.view)
        popUpController.didMove(toParent: self)
    }
    
    func addVC(vc: UIViewController) {
        removeCurrentVC()
        homeVC.addChild(vc)
        homeVC.view.addSubview(vc.view)
        vc.view.frame = view.frame
        vc.didMove(toParent: homeVC)
        homeVC.title = vc.title
    }
    
    func removeCurrentVC() {
        if homeVC.children.count > 0{
            let viewControllers:[UIViewController] = homeVC.children
            for viewController in viewControllers{
                viewController.view.removeFromSuperview()
                viewController.didMove(toParent: nil)
            }
        }
    }
}

extension ContainerViewController: HomeViewControlerDelegate {
    func didTapMenuButton(menu: HomeViewController.MenuOptions) {
        self.showMenuView(menuItem: menu)
    }
}

extension ContainerViewController: LoginViewControllerDelegate {
    func didUserLogin() {
        self.addVC(vc: playerVC)
    }
}

extension ContainerViewController: LogoutViewControllerDelegate {
    func didUserLogout() {
        self.addVC(vc: loginVC)
    }
}
