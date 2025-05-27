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
    var alarmChanged: ((Bool) -> Void)?

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

    private let toggleSwitch = UISwitch().then {
        $0.onTintColor = .primary500
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.overrideUserInterfaceStyle = .light
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            toggleSwitch
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

        toggleSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }

    func configure(
        hour: Int16,
        minute: Int16,
        detail: String,
        isEnabled: Bool
    ) {
        detailLabel.text = detail
        toggleSwitch.isOn = isEnabled
        configureLocale(hour: hour, minute: minute)
        configureLabelColor(to: isEnabled)
    }

    func configureLabelColor(to toggleSwitchValue: Bool) {
        if toggleSwitchValue {
            timeLabel.textColor = .neutral1000
            amPmLabel.textColor = .neutral1000
            detailLabel.textColor = .neutral1000
        } else {
            timeLabel.textColor = .neutral300
            amPmLabel.textColor = .neutral300
            detailLabel.textColor = .neutral300
        }
    }

    private func configureLocale(hour: Int16, minute: Int16) {
        if Locale.autoupdatingCurrent.uses24HourClock {
            timeLabel.text = String(format: "%02d:%02d", hour, minute)
            amPmLabel.isHidden = true
        } else {
            let displayHour = hour % 12 == 0 ? 12 : hour % 12
            timeLabel.text = String(format: "%02d:%02d", displayHour, minute)
            amPmLabel.text = hour < 12 ? "AM" : "PM"
            amPmLabel.isHidden = false
        }
    }

    func getToogleSwitch() -> UISwitch {
        return toggleSwitch
    }
}
