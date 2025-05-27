//
//  TimerRecentCell.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/20/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class TimerRecentCell: BaseTableViewCell {

    // MARK: - Properties

    let didTapStartButton = PublishRelay<Void>()

    // MARK: - UI Components

    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .leading
    }

    private let timeLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.font = .lightFont()
    }

    private let timeKRLabel = UILabel().then {
        $0.textColor = .neutral300
        $0.font = .systemFont(ofSize: 20, weight: .light)
    }

    private let startButton = UIButton().then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .regular)
        let playImage = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
        $0.setImage(playImage, for: .normal)
        $0.tintColor = .primary300
    }

    private let circleView = UIView().then {
        $0.backgroundColor = .primary200
        $0.layer.cornerRadius = 35
    }

    // MARK: - Init, Deinit, required

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
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
        contentView.addSubviews(labelStackView, circleView)

        labelStackView.addArrangedSubviews(timeLabel, timeKRLabel)

        circleView.addSubviews(startButton)

        labelStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
        }

        circleView.snp.makeConstraints {
            $0.leading.equalTo(labelStackView.snp.trailing).offset(20)
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(labelStackView)
            $0.size.equalTo(70)
        }

        startButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Bind

    private func bind() {
        startButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.didTapStartButton.accept(())
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    func configureCell(time: String, timeKR: String) {
        timeLabel.text = time
        timeKRLabel.text = timeKR
    }
}
