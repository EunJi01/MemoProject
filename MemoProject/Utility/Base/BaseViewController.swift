//
//  BaseViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        //tapGesture()
        navigationItemColor()
    }
    
    private func navigationItemColor() {
        let navigation = UINavigationBarAppearance()
        navigation.backgroundColor = .tertiarySystemFill
        navigationController?.navigationBar.scrollEdgeAppearance = navigation
        navigationController?.navigationBar.tintColor = ColorSet.shared.buttonColor
        navigationController?.toolbar.tintColor = ColorSet.shared.buttonColor
    }
    
    private func tapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false // 중요!
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func configure() {}
    
    func setConstraints() {}
    
    func showAlertMessage(title: String, button: String = "확인") { // 매개변수 기본값
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: button, style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
