//
//  TimerActiveCell.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/20/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class TimerActiveCell: BaseTableViewCell {

    // MARK: - Properties

    let didTapControlButton = PublishRelay<Void>()

    // MARK: - UI Components

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }

    private let timeLabel = UILabel().then {
        $0.textColor = .neutral1000
        $0.font = .lightFont()
    }

    private let timeKRLabel = UILabel().then {
        $0.textColor = .neutral1000
        $0.font = .systemFont(ofSize: 20, weight: .light)
    }

    private let controlButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)
        let playImage = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
        let pauseImage = UIImage(systemName: "pause.fill", withConfiguration: imageConfig)
        $0.setImage(pauseImage, for: .normal)
        $0.setImage(playImage, for: .selected)
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

        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout Cycles

    override func layoutSubviews() {
        super.layoutSubviews()

        DispatchQueue.main.async {
            self.setProgressPath()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bind()
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
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
        }

        controlButton.snp.makeConstraints {
            $0.leading.equalTo(labelStackView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(labelStackView)
            $0.size.equalTo(70)
        }
    }

    // MARK: - Bind

    private func bind() {
        controlButton.rx.tap
            .bind(to: didTapControlButton)
            .disposed(by: disposeBag)
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
        controlButton.isSelected = state == .pause
    }

    /// value: 0~1 사이의 값으로 진행도를 나타냄
    func updateProgress(value: CGFloat) {
        CATransaction.setDisableActions(true)
        progressLayer.strokeEnd = value
    }
}

extension TimerActiveCell {
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
