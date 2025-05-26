//
//  SelectCityView.swift
//  Beontteuk
//
//  Created by 백래훈 on 5/26/25.
//

import UIKit

import SnapKit
import Then

final class SelectCityView: BaseView {
    //MARK: UI Components
    let cityTableView = UITableView().then {
        $0.register(SelectCityTableViewCell.self, forCellReuseIdentifier: SelectCityTableViewCell.className)
        $0.backgroundColor = .clear
    }
    
    override func setStyles() {
        super.setStyles()
        
        self.addSubview(cityTableView)
    }
    
    override func setLayout() {
        super.setLayout()
        
        cityTableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
