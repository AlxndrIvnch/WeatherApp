//
//  UINavigatioonController + extension.swift
//  MusicApp
//
//  Created by Aleksandr on 23.07.2022.
//

import Foundation
import UIKit


extension UINavigationController {
    
    func customPushFromRight(_ vc: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .push
        transition.subtype = .fromRight
        view.window!.layer.add(transition, forKey: nil)
        pushViewController(vc, animated: false)
    }
    
    func customPop() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .reveal
        view.window!.layer.add(transition, forKey: nil)
        popViewController(animated: false)
    }
}
