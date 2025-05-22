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
    private var alarms: [Alarm] = Alarm.mockList

    override func loadView() {
        view = alarmView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        alarmView.tableView.dataSource = self
        alarmView.tableView.delegate = self
    }

    private func setNavigationItem() {
        navigationItem.leftBarButtonItem = CustomUIBarButtonItem(type: .edit(action: {
            print("EDIT")
        }))
    }

    private func didOnAddTap() {
        let bottomSheet = AlarmBottomSheetViewController()
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
extension AlarmViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AlarmTableViewListTypeCell.className, for: indexPath) as! AlarmTableViewListTypeCell
        let alarm = alarms[indexPath.row]
        let time = String(format: "%02d:%02d", alarm.hour, alarm.minute)
        let amPm = alarm.hour < 12 ? "AM" : "PM"
        cell.configure(time: time, amPm: amPm, detail: alarm.repeatText, isOn: alarm.isOn)
        return cell

    }

}

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
        viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: AlarmTableViewHeaderCell.className
        ) as! AlarmTableViewHeaderCell

        header.onAddTap = { [weak self] in
            self?.didOnAddTap()
            NSLog("Touch")
        }

        return header
    }

    func tableView(_ tableView: UITableView,
        heightForHeaderInSection section: Int) -> CGFloat {
        return 320 // 컨텐츠 전부 보여줄 높이
    }
}
