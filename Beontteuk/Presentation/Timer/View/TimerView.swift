//
//  TimerView.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class TimerView: BaseView {

    // MARK: - Properties

    let didTapRecentTimerButton = PublishRelay<Int>()
    let didItemDeleted = PublishRelay<IndexPath>()
    private var disposeBag = DisposeBag()
    private var dataSource: EditableDataSource<TimerSection, TimerItem>?

    // MARK: - UI Components

    private let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .clear
        $0.register(TimerActiveCell.self, forCellReuseIdentifier: TimerActiveCell.className)
        $0.register(TimerRecentCell.self, forCellReuseIdentifier: TimerRecentCell.className)
        $0.showsVerticalScrollIndicator = false
    }

    // MARK: - Init, Deinit, required

    override init(frame: CGRect) {
        super.init(frame: frame)
        setDataSource()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Layout Helper

    override func setLayout() {
        addSubviews(tableView)

        tableView.snp.makeConstraints {
            $0.top.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - DataSource Helper

    private func setDataSource() {
        dataSource = .init(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let section = TimerSection.allCases[indexPath.section]
            switch section {
            case .active:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TimerActiveCell.className,
                    for: indexPath
                ) as! TimerActiveCell

                if let timer = item.active {
                    cell.configureCell(
                        time: timer.timeString,
                        timeKR: timer.localizedTimeString,
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
                    cell.configureCell(
                        time: timer.timeString,
                        timeKR: timer.localizedTimeString
                    )

                    cell.didTapStartButton
                        .bind(with: self) { owner, _ in
                            owner.didTapRecentTimerButton.accept(indexPath.row)
                        }
                        .disposed(by: cell.disposeBag)
                }

                return cell
            }
        })

        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendSections(TimerSection.allCases)
        dataSource?.apply(snapshot)
    }

    // MARK: - Bind

    private func bind() {
        tableView.rx.itemDeleted
            .bind(with: self) { owner, indexPath in
                owner.didItemDeleted.accept(indexPath)
            }
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }

    func updateSnapshot(with items: [TimerItem], to section: TimerSection) {
        guard var snapshot = dataSource?.snapshot() else { return }
        let oldItems = snapshot.itemIdentifiers(inSection: section)
        snapshot.deleteItems(oldItems)
        snapshot.appendItems(items, toSection: section)
        dataSource?.apply(snapshot)
    }

    func toggleEditingTableView() {
        let isEditing = tableView.isEditing
        tableView.setEditing(!isEditing, animated: true)
    }
}

