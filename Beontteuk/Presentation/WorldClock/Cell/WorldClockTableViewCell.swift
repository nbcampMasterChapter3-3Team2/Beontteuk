//
//  WorldClockTableViewCell.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/23/25.
//

import UIKit

import SnapKit
import Then

final class WorldClockTableViewCell: BaseTableViewCell {
    //MARK: UI Components
    let dayTimeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .systemGray
    }
    
    let cityLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .regular)
        $0.textColor = .label
    }
    
    let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
    }
    
    let clockLabel = UILabel().then {
        $0.font = .lightFont()
        $0.textColor = .label
    }
    
    let amPmLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .regular)
        $0.textColor = .label
    }
    
    //MARK: SetStyles
    override func setStyles() {
        super.setStyles()
        
        self.selectionStyle = .none
        self.backgroundColor = .clear
    }
    
    //MARK: SetLayout
    override func setLayout() {
        super.setLayout()
        
        self.contentView.addSubviews(verticalStackView, clockLabel, amPmLabel)
        self.verticalStackView.addArrangedSubviews(dayTimeLabel, cityLabel)
        
        verticalStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        clockLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
        
        amPmLabel.snp.makeConstraints {
            $0.trailing.equalTo(clockLabel.snp.leading).offset(-3)
            $0.bottom.equalTo(verticalStackView.snp.bottom)
        }
    }
    
    func configureCell(with: WorldClockEntity) {
        self.dayTimeLabel.text = "\(with.dayLabelText), \(with.hourDifferenceText)"
        self.cityLabel.text = with.cityNameKR?.components(separatedBy: ", ").first ?? ""
        self.clockLabel.text = with.hourMinuteString
        self.amPmLabel.text = with.amPmString
        
        self.clockLabel.isHidden = with.isEditing
        self.amPmLabel.isHidden = with.isEditing
    }
}
