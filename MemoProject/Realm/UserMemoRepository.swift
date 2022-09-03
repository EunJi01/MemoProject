//
//  UserMemoRepository.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/02.
//

import Foundation
import RealmSwift

protocol UserMemoRepositoryType {
    func fetchMemo() -> Results<UserMemo>!
    func fetchFixedMemo() -> Results<UserMemo>!
    func updateItem(item: UserMemo, title: String, content: String) // 수정
    func updateFix(item: UserMemo) // 고정 등록/해제
    func deleteItem(item: UserMemo) // 삭제
//    func fetchFilter(text: String) -> [UserMemo] // 검색
}

class UserMemoRepository: UserMemoRepositoryType {
    let localRealm = try! Realm()
    
    func fetchMemo() -> Results<UserMemo>! {
        return localRealm.objects(UserMemo.self).filter("isFix == false").sorted(byKeyPath: "regdate", ascending: false)
    }
    
    func fetchFixedMemo() -> Results<UserMemo>! {
        return localRealm.objects(UserMemo.self).filter("isFix == true").sorted(byKeyPath: "regdate", ascending: false)
    }
    
    func updateItem(item: UserMemo, title: String, content: String) {
//        self.localRealm.create(UserMemo.self, value: ["objectID": item.objectID, "memoTitle": title, "memoContent": content, "regdate": Date()], update: .modified)
        item.memoTitle = title
        item.memoContent = content
        item.regdate = Date()
    }
    
    func updateFix(item: UserMemo) {
        try! localRealm.write {
            item.isFix = !item.isFix
        }
    }
    
    func deleteItem(item: UserMemo) {
        try! localRealm.write {
            localRealm.delete(item)
        }
    }
    
    func fetchFilter(text: String) -> [UserMemo] {
        var results: [UserMemo] = []
        results.append(contentsOf: localRealm.objects(UserMemo.self).filter("memoTitle CONTAINS[c] '\(text)'"))
        results.append(contentsOf: localRealm.objects(UserMemo.self).filter("memoContent CONTAINS[c] '\(text)'"))

        return results.uniqueArrItems() // 중복 제거
    }
}
