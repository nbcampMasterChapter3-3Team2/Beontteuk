//
//  AlarmTableViewHeaderCell.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit

import SnapKit
import Then

final class AlarmTableViewHeaderCell: BaseTableViewHeaderFooterView {

    private let alarmImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "alarmOff")
    }

    private let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .neutral1000
        $0.text = "예정된 알람이 없어요"
    }

    private let addButton = AddButton(type: .alarm)

    override func setLayout() {
        addSubviews(alarmImageView, descriptionLabel, addButton)

        alarmImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(186)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(alarmImageView.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }


        addButton.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview().inset(20)
        }
    }

    func configure() {
    }
}
