//
//  WriteViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/01.
//

import UIKit

final class WriteViewController: BaseViewController {
    let mainView = WriteView()
    let repository = UserMemoRepository()
    
    var memoTitle: String?
    var memoContent: String?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.userTextView.becomeFirstResponder() // 키보드 올리기 -> MARK: 메모 수정 상태에서는 동작 안하도록 조건문 구현 필요
    }
    
    override func configure() {
        mainView.userTextView.delegate = self
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
        // MARK: Realm 저장 코드 + 글자수 조건문 추가하기
        guard let title = mainView.userTextView.text, title.trimmingCharacters(in: .whitespaces) != "" else { return }
        let task = UserMemo(memoTitle: title, memoContent: nil)
        
        do {
            try repository.localRealm.write {
                repository.localRealm.add(task)
            }
        } catch let error {
            print(error)
        }
        mainView.userTextView.resignFirstResponder() // 키보드 내리기
    }
    
    @objc private func shareButtonTapped() {
        // MARK: UIActivityController 띄우기
    }
}

extension WriteViewController: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            print("주울바꿈")
//        }
//        return true
//    }
}
