//
//  LogoutViewController.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 21-03-22.
//

import UIKit

protocol LogoutViewControllerDelegate: AnyObject {
    func didUserLogout()
}

class LogoutViewController: UIViewController {

    weak var delegate: LogoutViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // put GA mark event
        didUserLogout()
        self.view.showLoading()
    }
    
    private func didUserLogout() {
        //remover los datos del usuario
        print("before DispatchQueue")
        Utils.setUserPlayList(url: nil)
        DispatchQueue.main.async {
            self.view.hideLoading()
            print("didUserLogout")
            self.delegate?.didUserLogout()
        }
    }
}
