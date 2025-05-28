//
//  AlarmView.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class AlarmView: BaseView {

    // MARK: - UI Components
    private let navigationBar = UINavigationBar().then {
        $0.backgroundColor = .clear
        $0.setBackgroundImage(UIImage(), for: .default)
        $0.shadowImage = UIImage()
        $0.isTranslucent = true
    }

    private let barItem = CustomUIBarButtonItem(type: .edit)

    private let header = AlarmTableViewHeader(reuseIdentifier: AlarmTableViewHeader.className).then {
        $0.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 320)
    }

    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.register(AlarmTableViewCell.self, forCellReuseIdentifier: AlarmTableViewCell.className)
        $0.separatorStyle = .singleLine
        $0.backgroundColor = .clear
    }

    // MARK: - Style Helper
    override func setStyles() {
        let navItem = UINavigationItem()
        navItem.leftBarButtonItem = barItem
        navigationBar.items = [navItem]
    }

    // MARK: - Layout Helper
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

        tableView.tableHeaderView = header
    }

    // MARK: - Getter Helper
    var editingToggle: ControlEvent<Void> {
        guard let btn = barItem.customView as? UIButton else {
            return ControlEvent<Void>(events: Observable<Void>.empty())
        }
        return btn.rx.tap
    }
    var openSheet: ControlEvent<Void> { header.getAddButton().rx.tap }
    func getTableView() -> UITableView { tableView }
    func getNavigationBar() -> UINavigationBar { navigationBar }

}

