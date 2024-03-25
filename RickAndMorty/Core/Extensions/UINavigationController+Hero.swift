//
//  UINavigationController+Hero.swift
//  RickAndMorty
//
//  Created by Uzma Sayyed on 2/8/24.
//

import Foundation
import UIKit
import Hero

extension UINavigationController {
    func show(_ viewController: UIViewController, navigationAnimationType: HeroDefaultAnimationType = .autoReverse(presenting: .slide(direction: .leading))) {
        viewController.hero.isEnabled = true
        hero.isEnabled = true
        hero.navigationAnimationType = navigationAnimationType
        pushViewController(viewController, animated: true)
    }
}
