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

    // MARK: - Properties

    private let viewModel = StopWatchViewModel()

    // MARK: - UI Components

    private let stopWatchView = StopWatchView()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataSource()
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

        viewModel.state.formattedTimeRelay
            .bind { [weak self] time in
                guard let self else { return }
                stopWatchView.updateTime(with: time)
            }.disposed(by: disposeBag)

        viewModel.state.stopWatchRelay
            .bind { [weak self] state in
                guard let self else { return }
                switch state {
                case .initial:
                    // TODO: 스톱워치 초기화
                    viewModel.action.stopWatchAction.accept(.reset)

                    stopWatchView.leftButton.updateButtonType(type: .lap)
                    stopWatchView.leftButton.isEnabled = false

                    stopWatchView.rightButton.updateButtonType(type: .start)
                case .progress:
                    // TODO: 스톱워치 시작
                    viewModel.action.stopWatchAction.accept(.start)

                    stopWatchView.leftButton.updateButtonType(type: .lap)
                    stopWatchView.leftButton.isEnabled = true

                    stopWatchView.rightButton.updateButtonType(type: .stop)
                case .pause:
                    // TODO: 스톱워치 일시정지
                    viewModel.action.stopWatchAction.accept(.pause)

                    stopWatchView.leftButton.updateButtonType(type: .reset)
                    stopWatchView.rightButton.updateButtonType(type: .start)
                }
            }.disposed(by: disposeBag)
    }

    private func start(_ text: String) {
        print("start: \(text)")
        stopWatchView.updateTime(with: text)
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
        stopWatchView.tableView.dataSource = self
    }
}

extension StopWatchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        45
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LapCell.className, for: indexPath) as! LapCell
        cell.selectionStyle = .none
        return cell
    }
}

extension StopWatchViewController: UITableViewDelegate {

}
