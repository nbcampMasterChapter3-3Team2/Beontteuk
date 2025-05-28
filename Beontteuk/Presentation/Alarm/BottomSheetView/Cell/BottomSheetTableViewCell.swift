//
//  BottomSheetTableViewCell.swift
//  Beontteuk
//
//  Created by yimkeul on 5/22/25.
//


import UIKit
import SnapKit
import Then
import RxCocoa

final class BottomSheetTableViewCell: BaseTableViewCell {

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

    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.overrideUserInterfaceStyle = .light
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Style Helper
    override func setStyles() {
        selectionStyle = .none
        backgroundColor = .neutral100
    }

    // MARK: - Layout Helper
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

    // MARK: - Methods
    /// - Parameters:
    ///   - option: 어떤 셀인지
    ///   - detail: repeat/sound의 상세 텍스트, label의 현재 입력값
    ///   - isOn: snooze 스위치 상태
    func configure(
        option: BottomSheetTableOption,
        detail: String? = nil,
        isOn: Bool = false
    ) {
        titleLabel.text = option.title

        // 일단 모두 숨김
        detailLabel.isHidden = true
        textField.isHidden = true
        toggleSwitch.isHidden = true

        switch option {

        case .label:
            textField.placeholder = option.detailText
            textField.text = detail
            textField.isHidden = false

        case .snooze:
            toggleSwitch.isOn = isOn
            toggleSwitch.isHidden = false
//        case .repeat:
//            selectionStyle = .default
//            accessoryType = .disclosureIndicator
//            detailLabel.text = "안 함"
//            detailLabel.isHidden = false

//        case .sound:
//            selectionStyle = .default
//            accessoryType = .disclosureIndicator
//            detailLabel.text = "기본"
//            detailLabel.isHidden = false
        }
    }

    // MARK: - Getter Helper
    var snoozeToggled: ControlProperty<Bool> { toggleSwitch.rx.value }
    // 텍스트 필드 텍스트를 방출
    var inputTextField: ControlProperty<String?> { textField.rx.text }
    func getTextField() -> UITextField { textField }
}

