//
//  StopWatchView.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit
import Then
import SnapKit

final class StopWatchView: UIView {

    // MARK: - UI Components

    private let iconImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "stopwatchOff")
    }

    private let timerLabel = UILabel().then {
        $0.text = "00:00.00"
        $0.font = .systemFont(ofSize: 64, weight: .semibold)
        $0.textAlignment = .center
        $0.textColor = .neutral1000
    }

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 24
    }

    let resetButton = DefaultButton(type: .lap)

    let startButton = DefaultButton(type: .start)

    let tableView = UITableView().then {
        $0.register(LapCell.self, forCellReuseIdentifier: LapCell.className)
        $0.backgroundColor = .background500
        $0.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Initializer, Deinit, requiered

    override init(frame: CGRect) {
        super.init(frame: frame)
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
            iconImageView,
            timerLabel,
            stackView,
            tableView
        ]
            .forEach { addSubviews($0) }

        [
            resetButton,
            startButton
        ]
            .forEach { stackView.addArrangedSubview($0) }

    }

    // MARK: - Layout Helper

    private func setLayout() {
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(242)
            $0.top.equalTo(36)
            $0.centerX.equalToSuperview()
        }

        timerLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(20)
            $0.directionalHorizontalEdges.equalToSuperview()
        }

        stackView.snp.makeConstraints {
            $0.top.equalTo(timerLabel.snp.bottom).offset(36)
            $0.directionalHorizontalEdges.equalToSuperview().inset(28)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(26)
            $0.bottom.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(28)
        }
    }
}
