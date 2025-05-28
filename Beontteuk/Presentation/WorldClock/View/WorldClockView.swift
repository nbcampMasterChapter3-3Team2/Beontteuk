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
    private let navigationBar = UINavigationBar().then {
        $0.backgroundColor = .clear
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
    }
    
    private let editButton = CustomUIBarButtonItem(type: .edit)
    
    private let worldClockTableView = UITableView().then {
        $0.register(WorldClockTableViewCell.self, forCellReuseIdentifier: WorldClockTableViewCell.className)
        $0.backgroundColor = .clear
    }
    
    //MARK: SetStyles
    override func setStyles() {
        super.setStyles()
        
        self.addSubviews(worldClockTableView, navigationBar)
        setNavigationBar()
    }
    
    //MARK: SetLayouts
    override func setLayout() {
        super.setLayout()
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        worldClockTableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: Methods
    func getWorldClockTableView() -> UITableView {
        return worldClockTableView
    }
    
    func getNavigationBar() -> UINavigationBar {
        return navigationBar
    }
    
    func getEditButton() -> CustomUIBarButtonItem {
        return editButton
    }
    
    func makeEmptyView() -> UIView {
        let label = UILabel()
        label.text = "세계 시계 없음"
        label.textAlignment = .center
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 25, weight: .medium)
        return label
    }
    
    //MARK: Private Methods
    private func setNavigationBar() {
        let item = UINavigationItem(title: "")
        item.leftBarButtonItem = editButton
        
        self.navigationBar.setItems([item], animated: true)
    }
}
