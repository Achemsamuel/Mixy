//
//  LaunchViewController.swift
//  Mixy
//
//  Created by Achem Samuel on 4/6/19.
//  Copyright © 2019 Achem Samuel. All rights reserved.
//

import UIKit


class LaunchViewController: UIViewController {
    
    let network: NetworkManager = NetworkManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.isUnreachable { _ in
            self.showOfflinePage()
        }
        NetworkManager.isReachable { _ in
            self.showMainPage()
        }
        
        let mainVCF = MainViewController()
        mainVCF.getApiKey()
        mainVCF.getGeneralMovieResults()
    }

    private func showOfflinePage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(
                withIdentifier: "NetworkUnavailable",
                sender: self
            )
        }
    }
    
    private func showMainPage() -> Void {
        DispatchQueue.main.async {
            self.performSegue(
                withIdentifier: "MainController",
                sender: self
            )
        }
    }
}
