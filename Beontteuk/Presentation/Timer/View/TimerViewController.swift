//
//  TimerViewController.swift
//  Beontteuk
//
//  Created by 곽다은 on 5/21/25.
//

import UIKit
import SnapKit
import Then

final class TimerViewController: BaseViewController {

    // MARK: - UI Components

    private let timerView = TimerView()

    // MARK: - View Life Cycle

    override func loadView() {
        view = timerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        timerView.setTableViewDelegate(self)
    }
}

extension TimerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = TimerSection.allCases[section]
        switch section {
        case .current:
            let header = TimerAddHeader()
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
        case .current: return 334
        case .recent: return 44
        }
    }
}
