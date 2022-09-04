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
            mainView.userTextView.text = task.memoContent == nil ? task.memoTitle : task.memoTitle + task.memoContent!
            memoTitle = task.memoTitle
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
        if (memoTitle?.trimmingCharacters(in: .whitespacesAndNewlines) == "") && (memoContent?.trimmingCharacters(in: .whitespacesAndNewlines) == "") {
            if let task = task {
                print("===내용 없음 / 메모 삭제===")
                repository.deleteItem(item: task)
            }
            navigationController?.popViewController(animated: true)
        } else {
            saveButtonTapped()
        }
    }

    @objc private func saveButtonTapped() {
        do {
            try repository.localRealm.write {
                if let task = task {
                    if self.memoTitle == task.memoTitle && self.memoContent == task.memoTitle {
                        print("===변경사항 없음===") // MARK: 실행 안됨ㅜㅜ... 수정 안해도 날짜가 바뀜 아마 맨밑 버그때문인듯
                        navigationController?.popViewController(animated: true)
                    }  else {
                        print("===기존 메모 수정 완료===")
                        repository.updateItem(item: task, title: self.memoTitle ?? task.memoTitle, content: self.memoContent)
                    }
                } else {
                    guard let title = memoTitle, title.trimmingCharacters(in: .whitespaces) != "" else { return }
                    let newTask = UserMemo(memoTitle: title, memoContent: memoContent)
                    repository.localRealm.add(newTask)
                    print("===새로운 매모 저장 완료===")
                }
            }
        } catch let error {
            print(error)
        }
        
        print("Title: \(memoTitle ?? "없음")")
        print("Content: \(memoContent ?? "없음")")
    
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func shareButtonTapped() {
        guard let title = mainView.userTextView.text, title.trimmingCharacters(in: .whitespaces) != "" else { return }
        let activityVC = UIActivityViewController(activityItems: [title, memoContent ?? ""], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.mail, .assignToContact]
        self.present(activityVC, animated: true)
    }
}

// MARK: 버그 - 마지막 글자 하나가 저장이 안되는 현상 + 줄바꿈이 불필요하게 하나씩 더 들어가는 현상
extension WriteViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let cuttingLine = mainView.userTextView.text.components(separatedBy: "\n") // 줄바꿈 기준으로 문자열 자르기
        memoTitle = cuttingLine[0] + "\n" // 0번째 인덱스를 제목으로 저장
        //print("Title: " + memoTitle!)
        
        let content = cuttingLine[1...].reduce("") { str, i in str + i + "\n"} // 배열 형태인 String 합치기
        memoContent = content
        //print("Content: " + content)
        
        return true
    }
}
