//
//  CustomUIBarButtonItem.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit

import SnapKit
import Then

enum NavigationButtonType {
    case edit(action: () -> Void)
    case check(action: () -> Void)
}

final class CustomUIBarButtonItem: UIBarButtonItem {

    convenience init(type: NavigationButtonType) {
        let button = UIButton().then {

            $0.tintColor = .primary300

            let size: CGFloat = 40
            $0.frame = CGRect(x: 0, y: 0, width: size, height: size)
            $0.backgroundColor = .neutral100
            $0.layer.cornerRadius = size / 2

            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.25
            $0.layer.shadowRadius = 5
            $0.layer.shadowOffset = CGSize(width: 1, height: 2.5)

        }

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)

        switch type {
        case .edit(let action):
            let trashMark = UIImage(
                systemName: "trash",
                withConfiguration: symbolConfig
            )

            button.setImage(trashMark, for: .normal)
            button.addAction(UIAction { _ in action() }, for: .touchUpInside)

        case .check(let action):
            let checkMark = UIImage(
                systemName: "checkmark",
                withConfiguration: symbolConfig
            )

            button.setImage(checkMark, for: .normal)
            button.addAction(UIAction { _ in action() }, for: .touchUpInside)
        }

        self.init(customView: button)
    }
}
