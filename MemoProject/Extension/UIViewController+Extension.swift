//
//  UIViewController+Extension.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit

extension UIViewController {
    enum TransitionStyle {
        case present // 네비게이션 없이 Present
        case presentNavigation // 네비게이션 임베드 Present
        case presentFullNavigation // 네비게이션 풀스크린
        case presentOverFull // 팝업용
        case push
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
        case .presentNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            self.present(nav, animated: true)
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        case .presentFullNavigation:
            let nav = UINavigationController(rootViewController: viewController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true)
        case .presentOverFull:
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true)
        }
    }
    
    func showDeleteAlert(completionHandler: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: "메모를 삭제하시겠습니까?", message: "삭제된 메모는 복구할 수 없습니다", preferredStyle: .alert)
        let ok = UIAlertAction(title: "삭제", style: .destructive, handler: completionHandler)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
