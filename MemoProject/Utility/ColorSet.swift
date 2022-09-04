//
//  ColorSet.swift
//  MemoProject
//
//  Created by 황은지 on 2022/08/31.
//

import UIKit

final class ColorSet {
    static let shared = ColorSet()
    private init() {}
    
    let popupBackgroundColor: UIColor = UIColor(named: "popupBackgroundColor") ?? .blue
    let buttonColor: UIColor = .systemOrange
    lazy var backgroundColor: UIColor = darkMode(lightColor: .systemGray5, darkColor: .black)
    lazy var viewObjectColor: UIColor = darkMode(lightColor: .white, darkColor: .darkGray)
    lazy var whiteAndBlack: UIColor = darkMode(lightColor: .white, darkColor: .black)
    lazy var blackAndWhite: UIColor = darkMode(lightColor: .black, darkColor: .white)
    
    private func darkMode(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .light {
                    return lightColor
                } else {
                    return darkColor
                }
            }
        } else {
            return lightColor
        }
    }
}
