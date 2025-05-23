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
        $0.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
        $0.register(<#T##nib: UINib?##UINib?#>, forHeaderFooterViewReuseIdentifier: <#T##String#>)
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
