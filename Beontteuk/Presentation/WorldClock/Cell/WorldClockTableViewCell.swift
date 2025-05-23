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
        $0.font = .systemFont(ofSize: 55, weight: .light)
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
        
        self.contentView.addSubviews(verticalStackView, clockLabel)
        self.verticalStackView.addArrangedSubviews(dayTimeLabel, cityLabel)
        
        verticalStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        clockLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.verticalEdges.equalToSuperview().inset(8)
        }
    }
    
    func configureCell(with: WorldClockDummy) {
        self.dayTimeLabel.text = with.timeDifference
        self.cityLabel.text = with.city
        self.clockLabel.text = with.time
    }
}
