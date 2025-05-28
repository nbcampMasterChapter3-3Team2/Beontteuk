//
//  AddButton.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/21/25.
//

import UIKit

final class AddButton: UIButton {
    private let type: ButtonType

    init(type: ButtonType) {
        self.type = type
        super.init(frame: .zero)
        setStyles()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setStyles() {
        layer.cornerRadius = 16
        backgroundColor = .neutral100

        var config = UIButton.Configuration.plain()

        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfig)?
            .withTintColor(.primary500, renderingMode: .alwaysOriginal)
        config.image = image

        let attributedTitle = AttributedString(type.text, attributes: .init([
            .foregroundColor: UIColor.primary500,
            .font: UIFont.systemFont(ofSize: 25, weight: .medium),
        ]))
        config.attributedTitle = attributedTitle

        config.imagePadding = 8
        config.contentInsets = .init(top: 12, leading: 24, bottom: 12, trailing: 24)

        self.configuration = config
        self.setNeedsUpdateConfiguration()
    }
}

extension AddButton {
    enum ButtonType {
        case alarm
        case timer
        case city

        var text: String {
            switch self {
            case .alarm: "알람 추가"
            case .timer: "타이머 추가"
            case .city: "도시 추가"
            }
        }
    }
}
