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

    // MARK: - Properties
    private let alarmView = AlarmView()
    private let viewModel: AlarmViewModel
    private let bottomSheetViewModel: AlarmBottomSheetViewModel

    // MARK: - Initializer
    init(viewModel: AlarmViewModel, bottomSheetViewModel: AlarmBottomSheetViewModel) {
        self.viewModel = viewModel
        self.bottomSheetViewModel = bottomSheetViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View Life Cycle
    override func loadView() {
        view = alarmView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindEditingToggle()
        bindOpenSheet()
        bindingReloadOnForeground()
    }

    // MARK: Bind
    override func bindViewModel() {
        fetchAlarms()
        bindAlarmList()
        bindNextAlarmHeader()
        bindDeleteCell()
        bindSelectCellForEdit()
    }

    // MARK: Methods
    /// 최초 화면 진입 시 알람 읽기 액션
    private func fetchAlarms() {
        viewModel.action.onNext(.readAlarm)
    }

    /// 알람 리스트 → 테이블뷰
    private func bindAlarmList() {
        viewModel.state.alarmsRelay
            .bind(to: alarmView.getTableView().rx.items(
                cellIdentifier: AlarmTableViewCell.className,
                cellType: AlarmTableViewCell.self
            )) { row, alarm, cell in
            // 레이블 기본값 처리
            guard var label = alarm.label else { return }
            label = label.isEmpty ? "알람" : label
            let repeatDays = alarm.repeatDays != nil ? ", \(alarm.repeatDays!)" : ""

            cell.configure(
                hour: alarm.hour,
                minute: alarm.minute,
                detail: label + repeatDays,
                isEnabled: alarm.isEnabled
            )

            // 스위치 토글
            cell.getToogleSwitch()
                .rx
                .controlEvent(.valueChanged)
                .withLatestFrom(cell.getToogleSwitch().rx.isOn)
                .subscribe(onNext: { isOn in
                // UI 갱신
                cell.configureLabelColor(to: isOn)
                // ViewModel에 토글 액션 전달
                self.viewModel.action.onNext(.toggle(index: row, isOn: isOn))
            })
                .disposed(by: cell.disposeBag)
        }
            .disposed(by: disposeBag)
    }

    /// 다음 알람 유무 → 헤더
    private func bindNextAlarmHeader() {
        viewModel.state.nextAlarmRelay
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] hasNext in
            guard let header = self?.alarmView
                .getTableView().tableHeaderView
            as? AlarmTableViewHeader else { return }
            header.configureHasNextAlarm(to: hasNext)
        })
            .disposed(by: disposeBag)
    }

    /// 스와이프 삭제 액션
    private func bindDeleteCell() {
        alarmView.getTableView().rx
            .itemDeleted
            .map { AlarmViewModel.Action.deleteAlarm(at: $0.row) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }

    /// 셀 탭 → 편집 시트 오픈
    private func bindSelectCellForEdit() {
        alarmView.getTableView().rx
            .modelSelected(CDAlarmEntity.self)
            .subscribe(with: self) { owner, alarm in
            owner.openBottomSheetView(type: .edit, alarm: alarm)
        }
            .disposed(by: disposeBag)
    }

    /// 앱이 포그라운드로 돌아올 때 리로드 트리거
    private func bindingReloadOnForeground() {
        NotificationCenter.default.rx
            .notification(UIApplication.willEnterForegroundNotification)
            .subscribe(with: self) { owner, _ in
            owner.alarmView.getTableView().reloadData()
        }
            .disposed(by: disposeBag)
    }

    /// 모달 띄우기
    private func bindOpenSheet() {
        alarmView.openSheet
            .subscribe(with: self) { owner, _ in
            owner.openBottomSheetView(type: .create)
        }
            .disposed(by: disposeBag)
    }

    /// 테이블 편집모드 전환
    private func bindEditingToggle() {
        alarmView.editingToggle
            .withLatestFrom(viewModel.state.isEditingRelay)
            .map { !$0 }
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] isEditing in
                guard
                    let self = self,
                    let navBar = self.alarmView.getNavigationBar().items?.first,
                    let barItem = navBar.leftBarButtonItem as? CustomUIBarButtonItem
                else { return }

                // 테이블 뷰 편집 모드 토글
                DispatchQueue.main.async {
                    self.alarmView.getTableView().setEditing(isEditing, animated: true)
                }
                // 아이콘 타입 변경
                let newType: CustomUIBarButtonItem.NavigationButtonType =
                    isEditing ? .check : .edit
                    barItem.updateType(newType)
            })
            .map(AlarmViewModel.Action.setEditingMode(isEditing:))
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }

    /// 모달 띄우기
    private func openBottomSheetView(type: BottomSheetType, alarm: CDAlarmEntity? = nil) {
        bottomSheetViewModel.state.didAction
            .take(1) // 한 번만 처리
        .subscribe(with: self) { owner, _ in
            owner.viewModel.action.onNext(.readAlarm)
        }
            .disposed(by: disposeBag)

        let bottomSheet = AlarmBottomSheetViewController(viewModel: bottomSheetViewModel, type: type, alarm: alarm)
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
