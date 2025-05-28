//
//  DefaultButton.swift
//  Beontteuk
//
//  Created by kingj on 5/21/25.
//

import UIKit
import SnapKit

final class DefaultButton: UIButton {

    // MARK: - Properties
    
    private var type: DefaultButtonType

    // MARK: - Initializer, Deinit, requiered

    init(type: DefaultButtonType) {
        self.type = type
        super.init(frame: .zero)
        configureDefaultButton()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Helper

    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(type.height)
        }
    }

    // MARK: - Methods

    private func configureDefaultButton() {
        var config = UIButton.Configuration.plain()

        config.baseForegroundColor = type.fgColor
        config.titleAlignment = .center
        config.attributedTitle = {
            var attributedTitle = AttributedString(type.text)
            attributedTitle.font = UIFont.systemFont(
                ofSize: type.fontSize,
                weight: .medium
            )
            return attributedTitle
        }()

        self.configuration = config
        self.layer.cornerRadius = 16
        self.backgroundColor = type.bgColor
    }

    /// 버튼의 타입을 변경
    func updateType(type: DefaultButtonType) {
        self.type = type
        configureDefaultButton()
    }
}

extension DefaultButton {
    enum DefaultButtonType {
        case reset
        case start
        case lap
        case stop
        case cancel

        var text: String {
            switch self {
            case .reset: return "재설정"
            case .start: return "시작"
            case .lap: return "랩"
            case .stop: return "중단"
            case .cancel: return "취소"
            }
        }

        var fgColor: UIColor {
            switch self {
            case .reset: return .neutral1000
            case .start: return .neutral100
            case .lap: return .neutral1000
            case .stop: return .neutral100
            case .cancel: return .neutral1000
            }
        }

        var bgColor: UIColor {
            switch self {
            case .reset: return .neutral100
            case .start: return .primary500
            case .lap: return .neutral100
            case .stop: return .neutral700
            case .cancel: return .neutral100
            }
        }

        var height: Int {
            return 60
        }

        var fontSize: CGFloat {
            return 24
        }
    }
}
