//
//  LapCell.swift
//  Beontteuk
//
//  Created by kingj on 5/22/25.
//

import UIKit
import Then
import SnapKit

final class LapCell: UITableViewCell {

    // MARK: - UI Components

    private let lapLabel = UILabel().then {
        $0.textColor = .neutral1000
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }

    private let lappedTimeLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }

    private let timeIntervalLabel = UILabel().then {
        $0.textColor = .neutral1000
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 18, weight: .medium)
    }
    
    // MARK: - Initializer, Deinit, requiered

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setStyle()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Style Helper

    private func setStyle() {
        backgroundColor = .background500
    }

    // MARK: - Hierarchy Helper

    private func setHierarchy() {
        [
            lapLabel,
            lappedTimeLabel,
            timeIntervalLabel,
        ]
            .forEach { addSubviews($0) }
    }

    // MARK: - Layout Helper

    private func setLayout() {
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

    func configureItems(_ lapModel: LapTestModel) {
        self.lapLabel.text = lapModel.lap
        self.lappedTimeLabel.text = lapModel.lappedTime
        self.timeIntervalLabel.text = lapModel.timeInterval
    }
}

