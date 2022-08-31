//
//  MemoListViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit

final class MemoListViewController: BaseViewController {
    
    let mainView = MemoListView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.backgroundColor = ColorSet.shared.backgroundColor // 왠지 BaseView랑 MemoListView에서 변경이 안됨ㅠㅠ
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentPopup()
    }
    
    override func configure() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "??개의 메모"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func presentPopup() {
        if UserDefaults.standard.bool(forKey: "popupOff") == false {
            transition(FirstPopupViewController(), transitionStyle: .presentOverFull)
        }
    }
}
