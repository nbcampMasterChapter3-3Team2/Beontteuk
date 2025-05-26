//
//  LapCell.swift
//  Beontteuk
//
//  Created by kingj on 5/22/25.
//

import UIKit
import Then
import SnapKit

final class LapCell: BaseTableViewCell {

    // MARK: - UI Components

    private let lapLabel = UILabel().then {
        $0.textColor = .neutral1000
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }

    private let lappedTimeLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }

    private let timeIntervalLabel = UILabel().then {
        $0.textColor = .neutral1000
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }

    // MARK: Reuse

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    // MARK: - Style Helper

    override func setStyles() {
        super.setStyles()
        backgroundColor = .clear
    }

    // MARK: - Layout Helper

    override func setLayout() {
        super.setLayout()
        contentView.addSubviews(lapLabel, lappedTimeLabel, timeIntervalLabel)

        lapLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }

        timeIntervalLabel.snp.makeConstraints {
            $0.width.equalTo(77)
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }

        lappedTimeLabel.snp.makeConstraints {
            $0.width.equalTo(77)
            $0.trailing.equalTo(timeIntervalLabel.snp.leading).offset(-31)
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Methods

    func configureItems() { }
}

