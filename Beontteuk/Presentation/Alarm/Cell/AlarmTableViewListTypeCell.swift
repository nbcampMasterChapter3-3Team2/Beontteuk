//
//  AlarmTableViewListTypeCell.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit
import SnapKit
import Then
import RxSwift

final class AlarmTableViewListTypeCell: BaseTableViewCell {

    private let timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 50, weight: .medium)
        $0.textColor = .neutral300
    }

    private let amPmLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .medium)
        $0.textColor = .neutral300
    }

    private let detailLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .neutral300
    }

    private let alarmSwitch = UISwitch().then {
        $0.onTintColor = .primary500
    }

    override func setStyles() {
        selectionStyle = .none
        backgroundColor = .clear
    }

    override func setLayout() {
        contentView.addSubviews(
            timeLabel,
            amPmLabel,
            detailLabel,
            alarmSwitch
        )

        timeLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }

        amPmLabel.snp.makeConstraints {
            $0.leading.equalTo(timeLabel.snp.trailing).offset(4)
            $0.firstBaseline.equalTo(timeLabel)
        }

        detailLabel.snp.makeConstraints {
            $0.top.equalTo(timeLabel.snp.bottom)
            $0.leading.equalTo(timeLabel)
        }

        alarmSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(
        time: String,
        amPm: String,
        detail: String,
        isOn: Bool
    ) {
        timeLabel.text = time
        amPmLabel.text = amPm
        detailLabel.text = detail
        alarmSwitch.isOn = isOn
    }
}
