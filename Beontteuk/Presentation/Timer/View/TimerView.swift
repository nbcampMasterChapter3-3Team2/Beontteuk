//
//  TimerView.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit
import SnapKit
import Then

final class TimerView: BaseView {

    enum TimerSection: Hashable, CaseIterable {
        case current
        case recent
    }

    // MARK: - Properties

    private var dataSource: UITableViewDiffableDataSource<TimerSection, TimerItem>?

    // MARK: - UI Components

    private let tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(TimerCurrentCell.self, forCellReuseIdentifier: TimerCurrentCell.className)
        $0.register(TimerRecentCell.self, forCellReuseIdentifier: TimerRecentCell.className)
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Init, Deinit, required

    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout Helper

    override func setLayout() {
        addSubviews(tableView)

        tableView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }

    private func setDataSource() {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let section = TimerSection.allCases[indexPath.section]
            switch section {
            case .current:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TimerCurrentCell.className,
                    for: indexPath
                ) as! TimerCurrentCell

                if let timer = item.current {
                    cell.configureCell(
                        time: timer.time,
                        timeKR: timer.timeKR,
                        progress: timer.progress
                    )
                }

                return cell

            case .recent:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TimerRecentCell.className,
                    for: indexPath
                ) as! TimerRecentCell

                if let timer = item.recent {
                    cell.configureCell(time: timer.time, timeKR: timer.timeKR)
                }

                return cell
            }
        })

        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendSections(TimerSection.allCases)
        snapshot.appendItems(TimerItem.currentItems, toSection: .current)
        snapshot.appendItems(TimerItem.recentItems, toSection: .recent)
        dataSource?.apply(snapshot)
    }
}
