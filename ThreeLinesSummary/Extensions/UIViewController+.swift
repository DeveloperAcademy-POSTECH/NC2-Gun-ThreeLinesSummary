//
//  UIViewController+.swift
//  ThreeLinesSummary
//
//  Created by 김남건 on 2022/12/24.
//

import UIKit

extension UIViewController {
    func setTabBarImage(imageName: String, title: String) {
        let configuration = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: imageName, withConfiguration: configuration)
        tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
    }
}
