//
//  SelectCityTableViewCell.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class SelectCityTableViewCell: BaseTableViewCell {
    //MARK: UI Components
    let cityNameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .label
    }
    
    override func setStyles() {
        super.setStyles()
        
        self.contentView.addSubview(cityNameLabel)
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        
        self.selectionStyle = .none
    }
    
    override func setLayout() {
        super.setLayout()
        
        cityNameLabel.snp.makeConstraints {
            $0.leading.equalTo(16)
            $0.verticalEdges.equalToSuperview().inset(16)
        }
    }
    
    func configureCell(with city: SelectCityEntity) {
        self.cityNameLabel.text = city.cityNameKR
    }
}
