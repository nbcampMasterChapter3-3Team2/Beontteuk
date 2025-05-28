//
//  StopWatchView.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit
import Then
import SnapKit

final class StopWatchView: BaseView {

    // MARK: - UI Components

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "stopwatchOff")
    }

    private let timerLabel = UILabel().then {
        $0.text = "00:00.00"
        $0.font = .lightFont().withSize(64)
        $0.textColor = .neutral1000
    }

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 24
    }

    let leftButton = DefaultButton(type: .lap).then {
        $0.setShadow(type: .large)
    }

    let rightButton = DefaultButton(type: .start).then {
        $0.setShadow(type: .large)
    }

    let tableView = UITableView().then {
        $0.register(LapCell.self, forCellReuseIdentifier: LapCell.className)
        $0.backgroundColor = .clear
        $0.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Style Helper

    override func setStyles() {
        super.setStyles()
        backgroundColor = .clear
    }

    // MARK: - Layout Helper

    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }

    override func setLayout() {
        super.setLayout()

        addSubviews(iconImageView, timerLabel, stackView, tableView)
        stackView.addArrangedSubviews(leftButton, rightButton)

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(242)
            $0.top.equalTo(36)
            $0.centerX.equalToSuperview()
        }

        timerLabel.snp.makeConstraints {
            $0.width.equalTo(275)
            $0.top.equalTo(iconImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(36)
            $0.directionalHorizontalEdges.equalToSuperview().inset(28)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(26)
            $0.bottom.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
        }
    }

    func updateTime(with time: String) {
        self.timerLabel.text = time
    }
}
