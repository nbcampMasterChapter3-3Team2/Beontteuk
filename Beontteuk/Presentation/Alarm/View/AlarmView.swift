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

    lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(AlarmTableViewListTypeCell.self, forCellReuseIdentifier: AlarmTableViewListTypeCell.className)
        $0.register(AlarmTableViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: AlarmTableViewHeaderCell.className)

        $0.isEditing = false
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
        $0.rowHeight = 125
    }

    
    override func setStyles() {

    }

    override func setLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

