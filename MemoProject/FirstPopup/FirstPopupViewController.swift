//
//  FirstPopupViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit

final class FirstPopupViewController: BaseViewController {
    let mainView = FirstPopupView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        mainView.popupButton.addTarget(self, action: #selector(popupButtonTapped), for: .touchUpInside)
    }
    
    @objc func popupButtonTapped() {
        UserDefaults.standard.set(true, forKey: "popupOff")
        dismiss(animated: true)
    }
}
