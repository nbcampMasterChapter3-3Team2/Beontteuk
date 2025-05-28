//
//  StopWatchViewController.swift
//  Beontteuk
//
//  Created by kingj on 5/21/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class StopWatchViewController: BaseViewController {

    typealias Section = StopWatchSection
    typealias Item = StopWatchItem

    // MARK: - Properties

    private let viewModel: StopWatchViewModel

    private var dataSource: UITableViewDiffableDataSource<Section, Item>?

    // MARK: - UI Components

    private let stopWatchView = StopWatchView()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
        viewModel.action.viewDidLoad.accept(())
    }

    // MARK: - Initializer, Deinit, requiered

    init(
        viewModel: StopWatchViewModel
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Bind

    override func bindViewModel() {
        super.bindViewModel()

        stopWatchView.leftButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self else { return }
                viewModel.action.buttonAction.accept(.leftButton)
            }.disposed(by: disposeBag)

        stopWatchView.rightButton.rx.tap
            .subscribe { [weak self] _ in
                guard let self else { return }
                viewModel.action.buttonAction.accept(.rightButton)
            }.disposed(by: disposeBag)

        viewModel.state.snapshotRelay
            .bind { [weak self] snapshot in
                guard let self,
                      let dataSource,
                      let snapshot else { return }
                dataSource.apply(snapshot)
            }.disposed(by: disposeBag)

        viewModel.state.stopWatchTimeLabelRelay
            .bind { [weak self] time in
                guard let self else { return }
                stopWatchView.updateTime(with: time)
            }.disposed(by: disposeBag)

        viewModel.state.stopWatchButtonRelay
            .bind { [weak self] state in
                guard let self else { return }
                switch state {
                case .initial:
                    stopWatchView.leftButton.updateType(type: .lap)
                    stopWatchView.leftButton.isEnabled = false

                    stopWatchView.rightButton.updateType(type: .start)
                case .progress:
                    stopWatchView.leftButton.updateType(type: .lap)
                    stopWatchView.leftButton.isEnabled = true

                    stopWatchView.rightButton.updateType(type: .stop)
                case .pause:
                    stopWatchView.leftButton.updateType(type: .reset)
                    stopWatchView.rightButton.updateType(type: .start)
                }
            }.disposed(by: disposeBag)
    }

    // MARK: - Style Helper

    override func setStyles() {
        super.setStyles()
        view.backgroundColor = .background500
    }

    // MARK: - Layout Helper

    override func setLayout() {
        super.setLayout()
        view.addSubviews(stopWatchView)

        stopWatchView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.bottom.equalToSuperview()
        }
    }

    // MARK: - Delegate Helper

    override func setDelegates() {
        stopWatchView.tableView.delegate = self
    }

    // MARK: - DataSource Helper

    private func setDataSource() {
        dataSource = UITableViewDiffableDataSource(
            tableView: stopWatchView.tableView,
            cellProvider: { tableView, indexPath, item in

                switch item {
                case .lap(let lap):
                    let cell = tableView.dequeueReusableCell(withIdentifier: LapCell.className) as! LapCell
                    cell.configureItems(with: lap)
                    return cell
                }
            })
    }
}

extension StopWatchViewController: UITableViewDelegate {

}
