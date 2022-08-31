//
//  MemoListView.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit
import SnapKit

class MemoListView: BaseView {
    let tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .gray
        return view
    }()
    
    let toolbar: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [tableView, toolbar].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(toolbar.snp.top)
            
        }
        
        toolbar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
