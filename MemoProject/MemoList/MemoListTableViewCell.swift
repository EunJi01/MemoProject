//
//  MemoListTableViewCell.swift
//  MemoProject
//
//  Created by 황은지 on 2022/09/01.
//

import UIKit
import SnapKit

final class MemoListTableViewCell: UITableViewCell {
    var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "제목"
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "날짜"
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        return view
    }()
    
    let contentLabel: UILabel = {
        let view = UILabel()
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 14)
        view.text = "내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용내용"
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        [titleLabel, dateLabel, contentLabel].forEach {
            addSubview($0)
        }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self).inset(20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.topMargin.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel)
            make.leadingMargin.equalTo(dateLabel.snp.trailing).offset(16)
            make.trailing.equalTo(self).inset(20)
        }
    }
}
