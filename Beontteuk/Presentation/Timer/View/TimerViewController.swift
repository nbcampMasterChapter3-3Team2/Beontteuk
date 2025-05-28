//
//  TimerViewController.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/21/25.
//

import UIKit
import SnapKit
import Then
import RxCocoa

final class TimerViewController: BaseViewController {

    // MARK: - Properties

    private let viewModel: TimerViewModel

    // MARK: - UI Components

    private let timerView = TimerView()
    private let editButton = CustomUIBarButtonItem(type: .edit)

    // MARK: - Init, Deinit, required

    init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - View Life Cycle

    override func loadView() {
        view = timerView
    }

    // MARK: - Style Helper

    override func setStyles() {
        navigationItem.leftBarButtonItem = editButton
    }

    // MARK: - Delegate Helper

    override func setDelegates() {
        timerView.setTableViewDelegate(self)
    }

    // MARK: - Bind

    override func bindViewModel() {
        viewModel.action.onNext(.viewDidLoad)

        if let button = editButton.customView as? UIButton {
            button.rx.tap
                .asDriver(onErrorDriveWith: .empty())
                .drive(with: self) { owner, _ in
                    owner.timerView.toggleEditingTableView()
                    owner.viewModel.action.onNext(.didTapEditButton)
                }
                .disposed(by: disposeBag)
        }

        viewModel.state.isEditMode
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, isEdit in
                owner.editButton.updateType(isEdit ? .check : .edit)
            }
            .disposed(by: disposeBag)

        timerView.didItemDeleted
            .map { TimerViewModel.Action.didDeletedTimerItem($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        timerView.didTapRecentTimerButton
            .map { TimerViewModel.Action.didTapRecentTimerButton($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        timerView.didTapTimerControlButton
            .map { TimerViewModel.Action.didTapTimerControlButton($0) }
            .bind(to: viewModel.action)
            .disposed(by: disposeBag)

        viewModel.state.activeTimers
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, timers in
                owner.timerView.updateSnapshot(with: timers, to: .active)
            }
            .disposed(by: disposeBag)

        viewModel.state.recentTimers
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, timers in
                owner.timerView.updateSnapshot(with: timers, to: .recent)
            }
            .disposed(by: disposeBag)

        viewModel.state.tick
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, _ in
                owner.timerView.updateVisibleTimerCells()
            }
            .disposed(by: disposeBag)
    }
}

extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = TimerSection.allCases[section]
        switch section {
        case .active:
            let header = TimerAddHeader()

            header.didTapAddButton
                .asDriver(onErrorDriveWith: .empty())
                .drive(with: self) { owner, _ in
                    owner.viewModel.action.onNext(.didTapAddButton)
                }
                .disposed(by: header.disposeBag)

            header.didTapCancelButton
                .asDriver(onErrorDriveWith: .empty())
                .drive(with: self) { owner, _ in
                    owner.viewModel.action.onNext(.didTapCancelButton)
                }
                .disposed(by: header.disposeBag)

            header.didTapStartButton
                .asDriver(onErrorDriveWith: .empty())
                .drive(with: self) { owner, _ in
                    owner.viewModel.action.onNext(.didTapStartButton)
                }
                .disposed(by: header.disposeBag)

            header.didChangeTimePicker
                .asDriver(onErrorDriveWith: .empty())
                .drive(with: self) { owner, time in
                    owner.viewModel.action.onNext(.didChangeTimePicker(time))
                }
                .disposed(by: header.disposeBag)

            viewModel.state.showTimePicker
                .asDriver(onErrorDriveWith: .empty())
                .drive(with: self) { owner, isShow in
                    header.resetTimePicker()
                    header.showTimePicker(isShow)
                }
                .disposed(by: header.disposeBag)

            viewModel.state.canStartTimer
                .asDriver(onErrorDriveWith: .empty())
                .drive(with: self) { owner, isEnabled in
                    header.updateStartButtonState(isEnabled)
                }
                .disposed(by: header.disposeBag)

            viewModel.state.shouldResetTimePicker
                .asDriver(onErrorDriveWith: .empty())
                .drive(with: self) { owner, _ in
                    header.resetTimePicker()
                }
                .disposed(by: header.disposeBag)

            return header
        case .recent:
            let label = UILabel().then {
                $0.text = "최근 항목"
                $0.font = .systemFont(ofSize: 20, weight: .semibold)
            }

            let containerView = UIView()
            containerView.addSubview(label)
            label.snp.makeConstraints {
                $0.top.directionalHorizontalEdges.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(8)
            }

            return containerView
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let section = TimerSection.allCases[section]
        switch section {
        case .active: return 334
        case .recent: return 44
        }
    }
}
