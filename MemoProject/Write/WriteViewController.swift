//
//  WriteViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/01.
//

import UIKit

final class WriteViewController: BaseViewController {
    
    let mainView = WriteView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configure() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = "메모"
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonTapped))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.setRightBarButtonItems([saveButton, shareButton], animated: true)
    }
    
    @objc private func saveButtonTapped() {
        // Realm 저장 코드 + 글자수 조건문
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        // UIActivityController
    }
}
