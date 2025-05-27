//
//  AlarmView.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit

import SnapKit
import Then

final class AlarmView: BaseView {

    private let navigationBar = UINavigationBar().then {
        $0.backgroundColor = .clear
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
    }

    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.className)
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
    }

    override func setLayout() {
        addSubviews(navigationBar, tableView)

        navigationBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(44)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func getTableView() -> UITableView {
        return tableView
    }
    func getNavigationBar() -> UINavigationBar {
        return navigationBar
    }

}

