//
//  RealmModel.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/02.
//

import Foundation
import RealmSwift

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
