//
//  AlarmViewController.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class AlarmViewController: BaseViewController {

    private let alarmView = AlarmView()
    private let viewModel = AlarmViewModel()

    override func loadView() {
        view = alarmView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setTableHeader()
        viewModel.action.onNext(.viewDidLoad)

        // 앱이 포그라운드로 돌아올 때 리로드 트리거
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(with: self) { owner, _ in
                owner.alarmView.getTableView().reloadData()
            }
            .disposed(by: disposeBag)
    }

    override func bindViewModel() {
        viewModel.state.alarmsRelay
            .bind(to: alarmView.getTableView().rx.items(
                cellIdentifier: AlarmTableViewListTypeCell.className,
                cellType: AlarmTableViewListTypeCell.self
            )) { row, alarm, cell in
                let label = alarm.label ?? "알람"
                let repeatDays = alarm.repeatDays != nil ? ", \(alarm.repeatDays!)" : ""

                cell.configure(hour: alarm.hour,
                               minute: alarm.minute,
                               detail: label + repeatDays,
                               isEnabled: alarm.isEnabled)

                cell.alarmChanged = { isOn in
                    cell.configureLabelColor(to: isOn)
                }
        }
            .disposed(by: disposeBag)


        viewModel.state.nextAlarmRelay
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { owner, hasNext in
                if let header = owner.alarmView
                    .getTableView()
                    .tableHeaderView as? AlarmTableViewHeaderCell {
                    header.configureHasNextAlarm(to: hasNext)
                }
            }
            .disposed(by: disposeBag)
    }

    private func setNavigationItem() {
        navigationItem.leftBarButtonItem = CustomUIBarButtonItem(type: .edit(action: {
            // 편집 모드 진입 로직
        }))
    }

    private func setTableHeader() {
        let header = AlarmTableViewHeaderCell(
            reuseIdentifier: AlarmTableViewHeaderCell.className
        )
        header.onAddTap = { [weak self] in
            self?.didOnAddTap()
        }
        header.frame = CGRect(
            x: 0,
            y: 0,
            width: alarmView.getTableView().bounds.width,
            height: 320
        )
        alarmView.getTableView().tableHeaderView = header
    }

    private func didOnAddTap() {
        let bottomSheet = AlarmBottomSheetViewController()
        let nav = UINavigationController(rootViewController: bottomSheet)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheet.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 16
        }
        present(nav, animated: true)
    }


}
