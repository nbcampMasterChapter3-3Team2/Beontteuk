//
//  StopWatchViewController.swift
//  Beontteuk
//
//  Created by kingj on 5/21/25.
//

import UIKit
import Then
import SnapKit
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
        viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LapCell.className, for: indexPath) as! LapCell
        cell.configureItems(viewModel.items[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }
}

extension StopWatchViewController: UITableViewDelegate {

}
