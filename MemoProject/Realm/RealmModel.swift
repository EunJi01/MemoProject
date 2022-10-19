//
//  RealmModel.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/02.
//

import Foundation
import RealmSwift

class Folder: Object {
    @Persisted var folderTitle: String
    @Persisted var memo: List<UserMemo>
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(title: String) {
        self.init()
        self.folderTitle = title
    }
}

class UserMemo: Object {
    @Persisted var memoTitle: String
    @Persisted var memoContent: String?
    @Persisted var regdate = Date()
    @Persisted var isFix: Bool
    
    @Persisted(primaryKey: true) var objectID: ObjectId
    
    convenience init(memoTitle:String, memoContent: String?) {
        self.init()
        self.memoTitle = memoTitle
        self.memoContent = memoContent
        self.regdate = Date()
        self.isFix = false
    }
}
