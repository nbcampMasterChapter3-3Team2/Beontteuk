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

    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(AlarmTableViewListTypeCell.self, forCellReuseIdentifier: AlarmTableViewListTypeCell.className)
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
        $0.rowHeight = 125
    }

    override func setLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func getTableView() -> UITableView {
        return tableView
    }

}

