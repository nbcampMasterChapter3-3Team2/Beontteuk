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
    private let viewModel: AlarmViewModel
    private let bottomSheetViewModel: AlarmBottomSheetViewModel

    init(viewModel: AlarmViewModel, bottomSheetViewModel: AlarmBottomSheetViewModel) {
        self.viewModel = viewModel
        self.bottomSheetViewModel = bottomSheetViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = alarmView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        setTableHeader()
        viewModel.action.onNext(.readAlarm)

        // 앱이 포그라운드로 돌아올 때 리로드 트리거
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(with: self) { owner, _ in
            owner.alarmView.getTableView().reloadData()
        }
            .disposed(by: disposeBag)

    }

    override func bindViewModel() {
        // 알람 리스트 바인딩
        viewModel.state.alarmsRelay
            .bind(to: alarmView.getTableView().rx.items(
                cellIdentifier: AlarmTableViewListTypeCell.className,
                cellType: AlarmTableViewListTypeCell.self
            )) { row, alarm, cell in
            guard var label = alarm.label else { return }
            label = label == "" ? "알람" : label

            let repeatDays = alarm.repeatDays != nil ? ", \(alarm.repeatDays!)" : ""
            cell.configure(
                hour: alarm.hour,
                minute: alarm.minute,
                detail: label + repeatDays,
                isEnabled: alarm.isEnabled
            )
            cell.alarmChanged = { isOn in
                cell.configureLabelColor(to: isOn)
            }

            cell.getToogleSwitch()
                .rx
                .controlEvent(.valueChanged)
                .withLatestFrom(cell.getToogleSwitch().rx.isOn)
                .map { isOn in
                AlarmViewModel.Action.toggle(index: row, isOn: isOn)
            }
                .bind(to: self.viewModel.action)
                .disposed(by: cell.disposeBag)

        }
            .disposed(by: disposeBag)

        // 다음 알람 유무 헤더 업데이트
        viewModel.state.nextAlarmRelay
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] hasNext in
            guard let header = self?.alarmView
                .getTableView()
                .tableHeaderView as? AlarmTableViewHeaderCell else { return }
            header.configureHasNextAlarm(to: hasNext)
        })
            .disposed(by: disposeBag)


        // 네비게이션 아이템 - 편집모드
        viewModel.state.isEditingRelay
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isEditing in
            guard
                let self = self,
                let navBar = self.alarmView.getNavigationBar().items?.first,
                let barItem = navBar.leftBarButtonItem
            as? CustomUIBarButtonItem
                else { return }

            let tableView = self.alarmView.getTableView()
            DispatchQueue.main.async {
                tableView.setEditing(isEditing, animated: true)
            }

            let newType: CustomUIBarButtonItem.NavigationButtonType =
                isEditing ? .check : .edit
            barItem.updateType(newType)
        })
            .disposed(by: disposeBag)

        /// cell  삭제
        alarmView.getTableView()
            .rx
            .itemDeleted
            .map { item in AlarmViewModel.Action.deleteAlarm(at: item.row) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        /// cell 눌러서 편집 하기
        alarmView.getTableView()
            .rx
            .modelSelected(CDAlarm.self)
            .subscribe(with: self) { owner, item in
            self.openbottomSheetView(type: .edit, alarm: item)
        }
            .disposed(by: disposeBag)

    }

    private func setNavigationItem() {
        let navigationBar = alarmView.getNavigationBar()

        let navItem = UINavigationItem()
        let barItem = CustomUIBarButtonItem(type: .edit)

        navItem.leftBarButtonItem = barItem

        navigationBar.items = [navItem]

        guard let btn = barItem.customView as? UIButton else { return }
        btn.rx.tap
            .withLatestFrom(viewModel.state.isEditingRelay)
            .map { !$0 }
            .map(AlarmViewModel.Action.setEditingMode(isEditing:))
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

    }

    private func setTableHeader() {
        let header = AlarmTableViewHeaderCell(
            reuseIdentifier: AlarmTableViewHeaderCell.className
        )
        header.onAddTap = { [weak self] in
            self?.openbottomSheetView(type: .create)
        }
        header.frame = CGRect(
            x: 0,
            y: 0,
            width: alarmView.getTableView().bounds.width,
            height: 320
        )
        alarmView.getTableView().tableHeaderView = header
    }

    private func openbottomSheetView(type: BottomSheetType, alarm: CDAlarm? = nil) {
        bottomSheetViewModel.state.didAction
            .take(1) // 한 번만 처리
        .subscribe(with: self) { owner, _ in
            owner.viewModel.action.onNext(.readAlarm)
        }
            .disposed(by: disposeBag)


        let bottomSheet = AlarmBottomSheetViewController(viewModel: bottomSheetViewModel, type: type, alarm: alarm)
        bottomSheet.configure()
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
