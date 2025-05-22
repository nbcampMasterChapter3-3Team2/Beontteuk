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

    typealias Option = AlarmBottomSheetTableViewCell.Option

    private let bottomSheetView = AlarmBottomSheetView()
    private var selections: [Option: String] = [:]
    private var snoozeEnabled: Bool = true

    override func loadView() {
        view = bottomSheetView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        bottomSheetView.tableView.dataSource = self
        bottomSheetView.tableView.delegate = self
    }

    private func setNavigationItem() {
        navigationItem.titleView = NavigationItemType.title.view()
        // cancel 버튼에 didTapCancel(_:) 연결
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: NavigationItemType.cancel(
                target: self,
                action: #selector(didTapCancel)
            ).view()
        )

        // save 버튼에 didTapSave(_:) 연결
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: NavigationItemType.save(
                target: self,
                action: #selector(didTapSave)
            ).view()
        )
    }

    @objc
    private func didTapCancel() {
        dismiss(animated: true)
    }

    @objc
    private func didTapSave() {
        // 저장 로직 호출
        dismiss(animated: true)
    }
}

extension AlarmBottomSheetViewController {

    enum NavigationItemType {
        case title
        case cancel(target: Any, action: Selector)
        case save(target: Any, action: Selector)

        func view() -> UIView {
            switch self {
            case .title:
                return UILabel().then {
                    $0.font = .systemFont(ofSize: 16, weight: .semibold)
                    $0.textColor = .neutral1000
                    $0.text = "알람 추가"
                }
            case .cancel(let target, let action):
                return UIButton().then {
                    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
                    $0.setTitle("취소", for: .normal)
                    $0.setTitleColor(.primary500, for: .normal)
                    $0.addTarget(target, action: action, for: .touchUpInside)
                }
            case .save(let target, let action):
                return UIButton().then {
                    $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
                    $0.setTitle("저장", for: .normal)
                    $0.tintColor = .primary500
                    $0.setTitleColor(.primary500, for: .normal)
                    $0.addTarget(target, action: action, for: .touchUpInside)
                }
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension AlarmBottomSheetViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Option.allCases.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = Option.allCases[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmBottomSheetTableViewCell.className, for: indexPath) as! AlarmBottomSheetTableViewCell
        cell.configure(
            option: option,
            detail: selections[option],
            isOn: snoozeEnabled
        )
        // 토글 변경 콜백
        cell.snoozeChanged = { [weak self] isOn in
            self?.snoozeEnabled = isOn
        }
        // 레이블 변경 콜백
        cell.labelChanged = { [weak self] text in
            self?.selections[.label] = text
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension AlarmBottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = Option.allCases[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        switch option {
        case .repeat:
            // 반복 선택 화면으로 push or present
            break
        case .label:
            // 레이블 입력 UI 띄우기
            break
        case .sound:
            // 사운드 선택 화면 띄우기
            break
        case .snooze:
            // 스위치라 별도 처리 없음
            break
        }
    }
}

