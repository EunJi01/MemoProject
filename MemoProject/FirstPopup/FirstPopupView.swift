//
//  FirstPopupView.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit
import SnapKit

class FirstPopupView: BaseView {
    let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorSet.shared.viewObjectColor
        view.layer.cornerRadius = 30
        return view
    }()
    
    let popupLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = """
        처음 오셨군요!
        환영합니다 :)
        
        당신만의 메모를 작성하고
        관리해보세요!
        """
        view.font = .boldSystemFont(ofSize: 24)
        return view
    }()
    
    let popupButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 12
        view.backgroundColor = ColorSet.shared.buttonColor
        view.setTitle("확인", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.font = .boldSystemFont(ofSize: 24)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = ColorSet.shared.popupBackgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure() {
        [popupView, popupLabel, popupButton].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        popupView.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
            make.height.equalTo(280)
            make.width.equalTo(300)
        }
        
        popupLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(popupView.snp.top).inset(32)
            make.leadingMargin.equalTo(popupView.snp.leading).inset(32)
        }
        
        popupButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(popupView).inset(20)
            make.height.equalTo(60)
        }
    }
}
