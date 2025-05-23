//
//  AlarmBottomSheetTableViewCell.swift
//  Beontteuk
//
//  Created by yimkeul on 5/22/25.
//


import UIKit
import SnapKit
import Then

final class AlarmBottomSheetTableViewCell: BaseTableViewCell {

    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.textColor = .neutral1000
    }
    private let detailLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.isHidden = true
    }

    private let textField = UITextField().then {
        $0.textColor = .neutral300
        $0.textAlignment = .right
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.isHidden = true
    }
    private let toggleSwitch = UISwitch().then {
        $0.onTintColor = .primary500
        $0.isHidden = true
    }

    // 클로저 or 델리게이트로 스위치/텍스트 변경 콜백
    var snoozeChanged: ((Bool) -> Void)?
    var labelChanged: ((String?) -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.overrideUserInterfaceStyle = .light
        textField.delegate = self
        toggleSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func setStyles() {
        selectionStyle = .none
        backgroundColor = .neutral100
    }

    override func setLayout() {
        contentView.addSubviews(
            titleLabel,
            detailLabel,
            textField,
            toggleSwitch
        )

        // 제목
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)

        }
        // 디테일 레이블 (repeat, sound)
        detailLabel.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.top.bottom.equalToSuperview().inset(8)
        }
        // 토글 스위치
        toggleSwitch.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)

        }
        // 텍스트필드 (label)
        textField.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }

    // MARK: - Configure
    /// - Parameters:
    ///   - option: 어떤 셀인지
    ///   - detail: repeat/sound의 상세 텍스트, label의 현재 입력값
    ///   - isOn: snooze 스위치 상태
    func configure(
        option: Option,
        detail: String?,
        isOn: Bool
    ) {
        titleLabel.text = option.title

        // 일단 모두 숨김
        detailLabel.isHidden = true
        textField.isHidden = true
        toggleSwitch.isHidden = true

        switch option {
        case .repeat, .sound:
            selectionStyle = .default
            accessoryType = .disclosureIndicator
            detailLabel.text = detail ?? option.detailText
            detailLabel.isHidden = false

        case .label:
            textField.placeholder = option.detailText
            textField.text = detail
            textField.delegate = self
            textField.isHidden = false

        case .snooze:
            toggleSwitch.isOn = isOn
            toggleSwitch.isHidden = false
        }
    }
}

