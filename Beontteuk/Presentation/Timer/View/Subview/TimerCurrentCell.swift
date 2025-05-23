//
//  TimerCurrentCell.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/20/25.
//

import UIKit
import SnapKit
import Then

final class TimerCurrentCell: BaseTableViewCell {

    // MARK: - UI Components

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }

    private let timeLabel = UILabel().then {
        $0.textColor = .neutral1000
        $0.font = .systemFont(ofSize: 50, weight: .medium)
    }

    private let timeKRLabel = UILabel().then {
        $0.textColor = .neutral1000
        $0.font = .systemFont(ofSize: 20, weight: .medium)
    }

    private let controlButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)
        let playImage = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
        let pauseImage = UIImage(systemName: "pause.fill", withConfiguration: imageConfig)
        $0.setImage(playImage, for: .normal)
        $0.setImage(pauseImage, for: .selected)
        $0.tintColor = .primary500
    }

    private let progressLayer = CAShapeLayer().then {
        $0.strokeColor = UIColor.primary500.cgColor
        $0.fillColor = UIColor.clear.cgColor
        $0.lineWidth = 5
        $0.strokeEnd = 1.0
    }

    // MARK: - Init, Deinit, required

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        updateState(to: .running)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout Cycles

    override func layoutSubviews() {
        super.layoutSubviews()

        setProgressPath()
    }

    // MARK: - Style Helper

    override func setStyles() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    // MARK: - Layout Helper

    override func setLayout() {
        contentView.addSubviews(labelStackView, controlButton)

        labelStackView.addArrangedSubviews(timeLabel, timeKRLabel)

        controlButton.layer.addSublayer(progressLayer)

        labelStackView.snp.makeConstraints {
            $0.verticalEdges.leading.equalToSuperview().inset(20)
        }

        controlButton.snp.makeConstraints {
            $0.leading.equalTo(labelStackView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalTo(labelStackView)
            $0.size.equalTo(70)
        }
    }

    // MARK: - Methods

    private func setProgressPath() {
        progressLayer.frame = controlButton.bounds
        let center = CGPoint(x: progressLayer.bounds.midX, y: progressLayer.bounds.midY)
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: 32.5,// (button frame size - stroke line width) / 2
            startAngle: -.pi / 2,
            endAngle: .pi * 3 / 2,
            clockwise: true
        )
        progressLayer.path = circularPath.cgPath
    }

    func configureCell(time: String, timeKR: String, progress: CGFloat) {
        timeLabel.text = time
        timeKRLabel.text = timeKR
        updateProgress(value: progress)
    }

    func updateState(to state: TimerState) {
        timeLabel.textColor = state.labelColor
        timeKRLabel.textColor = state.labelColor
        controlButton.isSelected = state == .running
    }

    /// value: 0~1 사이의 값으로 진행도를 나타냄
    func updateProgress(value: CGFloat) {
        progressLayer.strokeEnd = value
    }
}

extension TimerCurrentCell {
    enum TimerState {
        case running
        case pause

        var labelColor: UIColor {
            switch self {
            case .running: .neutral1000
            case .pause: .neutral300
            }
        }
    }
}
