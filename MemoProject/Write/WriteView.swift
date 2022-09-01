//
//  WriteView.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/01.
//

import UIKit
import SnapKit

class WriteView: BaseView {
    let userTextView: UITextView = {
        let view = UITextView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorSet.shared.blackAndWhite
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [userTextView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        userTextView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }
}
