//
//  AlarmBottomSheetViewController.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxDataSources

final class AlarmBottomSheetViewController: BaseViewController {

    // MARK: - Properties
    private let bottomSheetView = AlarmBottomSheetView()
    private let viewModel: AlarmBottomSheetViewModel
    private let type: BottomSheetType?
    private let alarm: CDAlarmEntity?

    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .neutral1000
    }

    private let saveButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitle("저장", for: .normal)
        $0.tintColor = .primary500
        $0.setTitleColor(.primary500, for: .normal)
    }

    private let cancelButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.primary500, for: .normal)
    }

    // MARK: - Initializer
    init(viewModel: AlarmBottomSheetViewModel, type: BottomSheetType,
         alarm: CDAlarmEntity? = nil) {
        self.viewModel = viewModel
        self.type = type
        self.alarm = alarm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - View Life Cycle
    override func loadView() {
        view = bottomSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
    }

    // MARK: - Bind
    override func bindViewModel() {
        bindTableSections()
        bindingDatePicker()
        bindingNavigationItem()
        bindingActionDeleteCell()
    }

    // MARK: - Methods
    private func bindTableSections() {
        let dataSource = RxTableViewSectionedReloadDataSource<BottomSheetSectionModel>(
            configureCell: { [weak self] ds, tv, ip, item in
                switch item {
                case .option(let option):
                    guard let cell = tv.dequeueReusableCell(
                        withIdentifier: BottomSheetTableViewCell.className,
                        for: ip
                    ) as? BottomSheetTableViewCell else { return UITableViewCell() }

                    // 초기값 detail/isOn 결정
                    let detail: String?
                    let isOn: Bool
                    if self?.type == .edit, let alarm = self?.alarm {
                        switch option {
                        case .label:
                            detail = alarm.label
                            isOn = false
                        case .snooze:
                            detail = nil
                            isOn = alarm.isSnoozeEnabled
                        }
                    } else {
                        detail = nil
                        isOn = false
                    }

                    cell.configure(option: option, detail: detail, isOn: isOn)

                    // Rx 바인딩
                    switch option {
                    case .label:
                        cell.getTextField()
                            .rx
                            .controlEvent(.editingDidBegin)
                            .subscribe(onNext: {
                                cell.getTextField().text = ""
                            })
                            .disposed(by: cell.disposeBag)

                        cell.inputTextField
                            .orEmpty
                            .map(AlarmBottomSheetViewModel.Action.labelChanged)
                            .bind(to: self!.viewModel.action)
                            .disposed(by: cell.disposeBag)

                    case .snooze:
                        cell.snoozeToggled
                            .map(AlarmBottomSheetViewModel.Action.toggleSnooze)
                            .bind(to: self!.viewModel.action)
                            .disposed(by: cell.disposeBag)
                    }

                    return cell

                case .delete:
                    let cell = tv.dequeueReusableCell(
                        withIdentifier: "DeleteCell",
                        for: ip
                    )
                    cell.selectionStyle = .none
                    cell.backgroundColor = .neutral100
                    cell.textLabel?.text = "알람 삭제"
                    cell.textLabel?.textColor = .red500
                    cell.textLabel?.textAlignment = .center
                    return cell
                }
            }
        )
        // 2) 섹션 모델 생성
        let options = BottomSheetTableOption.allCases.map(BottomSheetItem.option)
        let deleteItem = BottomSheetItem.delete
        var sections = [
            BottomSheetSectionModel(header: nil, items: options)]
        if type == .edit {
            sections.append(
                BottomSheetSectionModel(header: nil, items: [deleteItem])
            )
        }

        // 3) 바인딩
        Observable.just(sections)
            .bind(to: bottomSheetView.getTableView().rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func bindingNavigationItem() {
        saveButton.rx.tap
            .do(onNext: { [weak self] in
            self?.dismiss(animated: true)
        })
            .map { [weak self] in
            if let alarm = self?.alarm {
                return AlarmBottomSheetViewModel.Action.update(alarm: alarm, repeatDays: nil, soundName: nil)
            } else {
                return AlarmBottomSheetViewModel.Action.save(repeatDays: nil, soundName: nil)
            }
        }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        cancelButton.rx.tap
            .do(onNext: { [weak self] in
            self?.dismiss(animated: true)
        })
            .map { .cancel }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }

    private func bindingDatePicker() {
        if type == .edit, let alarm = alarm {
            let dateComponents = DateComponents(hour: Int(alarm.hour), minute: Int(alarm.minute))
            let initial = Calendar.current.date(from: dateComponents)
            bottomSheetView.getTimePicker().date = initial ?? Date()

            bottomSheetView.dateChanged
            .map { AlarmBottomSheetViewModel.Action.dateChanged($0) }
            .bind(to: viewModel.action)
                .disposed(by: disposeBag)
        } else {
            bottomSheetView.dateChanged
                .map { AlarmBottomSheetViewModel.Action.dateChanged($0) }
                .bind(to: viewModel.action)
                .disposed(by: disposeBag)
        }
    }

    private func bindingActionDeleteCell() {
        let tableView = bottomSheetView.getTableView()

        tableView.rx
            .modelSelected(BottomSheetItem.self)
            .filter { item in
            if case .delete = item { return true }
            return false
        }
            .subscribe(with: self) { owner, item in
            guard let alarm = owner.alarm else { return }
            owner.viewModel.action.onNext(.delete(alarm: alarm))
            owner.dismiss(animated: true)
        }
            .disposed(by: disposeBag)
    }

    private func setNavigationItem() {
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        titleLabel.text = type == .create ? "알람 추가" : "알람 편집"
    }
}
