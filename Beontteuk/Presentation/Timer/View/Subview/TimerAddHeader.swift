//
//  TimerAddHeader.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/22/25.
//

import UIKit
import SnapKit
import Then

final class TimerAddHeader: BaseTableViewHeaderFooterView {

    // MARK: - UI Components

    // Idle
    private let idleStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.isHidden = true
    }

    private let bellImageView = UIImageView().then {
        $0.image = .timerOff
        $0.contentMode = .scaleAspectFit
    }

    private let addButton = AddButton(type: .timer).then {
        $0.setShadow(type: .large)
    }

    // Add
    private let addStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.isHidden = false
    }

    private let timePicker = UIPickerView()

    private let timeStackView = UIStackView().then {
        $0.distribution = .fillEqually
    }

    private let hourLabel = UILabel().then {
        $0.text = "시간"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .neutral1000
    }

    private let munuteLabel = UILabel().then {
        $0.text = "분"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .neutral1000
    }

    private let secondLabel = UILabel().then {
        $0.text = "초"
        $0.font = UIFont.boldSystemFont(ofSize: 20)
        $0.textColor = .neutral1000
    }

    private let buttonStackView = UIStackView().then {
        $0.spacing = 24
    }

    private let cancelButton = DefaultButton(type: .cancel).then {
        $0.setShadow(type: .large)
    }

    private let startButton = DefaultButton(type: .start).then {
        $0.setShadow(type: .large)
    }

    // MARK: - Init, Deinit, required

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        timePicker.delegate = self
        timePicker.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Layout Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        addButton.updateShadowPath()
        cancelButton.updateShadowPath()
        startButton.updateShadowPath()

        timeStackView.snp.removeConstraints()
        timeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(timePicker.rowSize(forComponent: 0).width / 2 + 36)
            $0.centerY.equalToSuperview()
            $0.width.equalToSuperview().inset(8)
        }
    }

    // MARK: - Layout Helper

    override func setLayout() {
        contentView.addSubviews(idleStackView, addStackView)

        idleStackView.addArrangedSubviews(bellImageView, addButton)

        addStackView.addArrangedSubviews(timePicker, buttonStackView)

        buttonStackView.addArrangedSubviews(cancelButton, startButton)

        timePicker.addSubviews(timeStackView)

        timeStackView.addArrangedSubviews(hourLabel, munuteLabel, secondLabel)

        idleStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
        }

        bellImageView.snp.makeConstraints {
            $0.size.equalTo(190)
        }

        addStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(32)
        }
    }
}

extension TimerAddHeader {
    enum State {
        case idle
        case add
    }
}

extension TimerAddHeader: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: return 24
        case 1,2: return 60
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(row)"
    }
}
