//
//  WriteViewController.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/01.
//

import UIKit
import RealmSwift

final class WriteViewController: BaseViewController {
    let mainView = WriteView()
    let repository = UserMemoRepository()
    
    var memoTitle: String?
    var memoContent: String?
    var task: UserMemo?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let task = task {
            mainView.userTextView.text = task.memoTitle
        } else {
            mainView.userTextView.becomeFirstResponder() // 키보드 올리기
        }
    }
    
    override func configure() {
        mainView.userTextView.delegate = self
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.title = "메모"
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        let saveButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonTapped))
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        navigationItem.setRightBarButtonItems([saveButton, shareButton], animated: true)
    }
    
    @objc private func backButtonTapped() {
        saveButtonTapped()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func saveButtonTapped() { // MARK: 내용 없으면 삭제하기 구현 필요
        guard let title = mainView.userTextView.text, title.trimmingCharacters(in: .whitespaces) != "" else { return }
        
        do {
            try repository.localRealm.write {
                if let task = task {
                    repository.updateItem(item: task, title: title, content: memoContent ?? "")
                } else {
                    let newTask = UserMemo(memoTitle: title, memoContent: memoContent ?? "")
                    repository.localRealm.add(newTask)
                }
            }
        } catch let error {
            print(error)
        }
        
        mainView.userTextView.resignFirstResponder() // 키보드 내리기
    }
    
    @objc private func shareButtonTapped() {
        guard let title = mainView.userTextView.text, title.trimmingCharacters(in: .whitespaces) != "" else { return }
        let activityVC = UIActivityViewController(activityItems: [title, memoContent ?? ""], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.mail, .assignToContact]
        self.present(activityVC, animated: true)
    }
}

extension WriteViewController: UITextViewDelegate { // MARK: 줄바꿈으로 타이틀/내용 구분 구현 필요
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if text == "\n" {
//            print("주울바꿈")
//        }
//        return true
//    }
}
