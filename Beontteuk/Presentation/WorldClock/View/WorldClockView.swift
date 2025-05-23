//
//  WorldClockView.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit

import SnapKit
import Then

final class WorldClockView: BaseView {
    //MARK: UI Components
    private let worldClockTableView = UITableView().then {
        $0.register(WorldClockTableViewCell.self, forCellReuseIdentifier: WorldClockTableViewCell.className)
        $0.register(WorldClockTableHeaderView.self, forHeaderFooterViewReuseIdentifier: WorldClockTableHeaderView.className)
        $0.backgroundColor = .clear
        $0.tableHeaderView = WorldClockTableHeaderView()
    }
    
    //MARK: SetStyles
    override func setStyles() {
        super.setStyles()
        
        self.addSubview(worldClockTableView)
        
    }
    
    //MARK: SetLayouts
    override func setLayout() {
        super.setLayout()
        
        worldClockTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    //MARK: Methods
    func getWorldClockTableView() -> UITableView {
        return worldClockTableView
    }
    
}
