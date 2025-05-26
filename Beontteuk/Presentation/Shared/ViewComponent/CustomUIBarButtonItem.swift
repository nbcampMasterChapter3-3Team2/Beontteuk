//
//  CustomUIBarButtonItem.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit

import SnapKit
import Then


final class CustomUIBarButtonItem: UIBarButtonItem {
    convenience init(type: NavigationButtonType) {
        let button = ShadowButton().then {

            $0.tintColor = .primary300
            let size: CGFloat = 40
            $0.frame = CGRect(x: 0, y: 0, width: size, height: size)
            $0.backgroundColor = .neutral100
            $0.layer.cornerRadius = size / 2

            $0.setShadow(type: .small)
        }
        self.init(customView: button)
        self.updateType(type)
    }

}

extension CustomUIBarButtonItem {
    enum NavigationButtonType {
        case edit
        case check
    }
}

extension CustomUIBarButtonItem {
    func updateType(_ type: NavigationButtonType) {
        guard let btn = customView as? UIButton else { return }

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let imageName: String = {
            switch type {
            case .edit: return "trash"
            case .check: return "checkmark"
            }
        }()

        btn.setImage(UIImage(systemName: imageName, withConfiguration: symbolConfig), for: .normal)
    }
}
