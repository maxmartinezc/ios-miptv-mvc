//
//  LogoutViewController.swift
//  mitvmvc
//
//  Created by Max Martinez Cartagena on 21-03-22.
//

import UIKit
import FirebaseAnalytics

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
        didUserLogout()
        self.view.showLoading()
    }
    
    private func didUserLogout() {
        Analytics.logEvent(K.TagManager.Logout.varName, parameters: [
            K.TagManager.CommonEventParameter.username: Utils.getUsername()!
        ])
        
        Utils.setUserPlayList(url: nil)
        Utils.setLastPlayedChannel(row: nil)
        Utils.setUsername(username: nil)
        self.view.hideLoading()
        DispatchQueue.main.async {
            self.delegate?.didUserLogout()
        }
    }
}
