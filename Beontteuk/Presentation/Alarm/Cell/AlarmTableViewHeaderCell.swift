//
//  AlarmTableViewHeaderCell.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit

import SnapKit
import Then
import RxCocoa

final class AlarmTableViewHeaderCell: BaseTableViewHeaderFooterView {

    var onAddTap: (() -> Void)?

    private let alarmImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .neutral1000
    }

    private let addButton = AddButton(type: .alarm).then {
        $0.setShadow(type: .large)
    }

    override func layoutSubviews() {
        addButton.updateShadowPath()
    }

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
            $0.directionalHorizontalEdges.equalToSuperview().inset(20).priority(.high)
            $0.height.equalTo(60)
        }
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func bind() {
        addButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.onAddTap?()
            }
            .disposed(by: disposeBag)
    }


    func configureHasNextAlarm(to nextAlarm: Bool) {
        alarmImageView.image = UIImage(named: nextAlarm ? "alarmOn" : "alarmOff")
        descriptionLabel.text = nextAlarm ? "활성화된 알람이 있어요" : "예정된 알람이 없어요"
    }

    func configure() {
    }
}
