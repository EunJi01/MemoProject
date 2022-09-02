//
//  UserMemoRepository.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/02.
//

import Foundation
import RealmSwift

protocol UserMemoRepositoryType {
    //func fetch() -> Results<UserMemo>! // 불러오기
    func updateItem(item: UserMemo) // 수정하기
    func updateFix(item: UserMemo) // 고정 등록/해제
    func deleteItem(item: UserMemo) // 지우기
    //
}

class UserMemoRepository: UserMemoRepositoryType {
    let localRealm = try! Realm()
    
//    func fetch() -> Results<UserMemo>! {
//        return localRealm.objects(UserMemo.self).sorted(byKeyPath: "regdate", ascending: false)
//    }
    
    func fetchMemo() -> Results<UserMemo>! {
        return localRealm.objects(UserMemo.self).filter("isFix == false").sorted(byKeyPath: "regdate", ascending: false)
    }
    
    func fetchFixedMemo() -> Results<UserMemo>! {
        return localRealm.objects(UserMemo.self).filter("isFix == true").sorted(byKeyPath: "regdate", ascending: false)
    }
    
    func updateItem(item: UserMemo) {
        self.localRealm.create(UserMemo.self, value: [], update: .modified)
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
}
