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
import RxCocoa

final class AlarmBottomSheetViewController: BaseViewController {

    private let bottomSheetView = AlarmBottomSheetView()
    private let viewModel = AlarmBottomSheetViewModel()

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .neutral1000
        $0.text = "알람 추가"
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

    override func loadView() {
        view = bottomSheetView
    }

    override func bindViewModel() {
        Observable.just(AlarmSheetTableOption.allCases)
            .bind(to: bottomSheetView.getTableView().rx.items(
                cellIdentifier: AlarmBottomSheetTableViewCell.className,
                cellType: AlarmBottomSheetTableViewCell.self
            )) { [weak self] row, option, cell in
            guard let self else { return }
            let detail = self.viewModel.state.selections.value[option]
            let isOn = self.viewModel.state.snoozeEnabled.value

            // 셀 구성
            cell.configure(option: option,
                detail: detail,
                isOn: isOn)

            cell.snoozeToggled
                .map(AlarmBottomSheetViewModel.Action.toggleSnooze)
                .bind(to: self.viewModel.action)
                .disposed(by: cell.disposeBag)

            cell.labelText
                .map { AlarmBottomSheetViewModel.Action.updateSelection(.label, $0) }
                .bind(to: self.viewModel.action)
                .disposed(by: cell.disposeBag)


        }
            .disposed(by: disposeBag)

        bottomSheetView.dateChanged
        .map { AlarmBottomSheetViewModel.Action.dateChanged($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        bindingNavigationItem()
    }


    private func setNavigationItem() {
        navigationItem.titleView = titleLabel
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }

    private func bindingNavigationItem() {
        saveButton.rx.tap
            .do(onNext: { [weak self] in
            self?.dismiss(animated: true)
        })
            .map { .save }
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
}
