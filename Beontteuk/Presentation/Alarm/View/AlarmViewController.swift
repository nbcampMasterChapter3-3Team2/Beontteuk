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

// 1) 알람 모델 정의
struct Alarm {
    let id: UUID
    let hour: Int
    let minute: Int
    let repeatText: String // 예: "알람, 주중"
    let isOn: Bool
}

// 2) 목 데이터 선언 (여기에 원하는 만큼 추가)
extension Alarm {
    static let mockList: [Alarm] = [
        Alarm(id: .init(), hour: 7, minute: 10, repeatText: "알람, 주중", isOn: true),
        Alarm(id: .init(), hour: 8, minute: 30, repeatText: "운동 알람", isOn: false),
        Alarm(id: .init(), hour: 21, minute: 0, repeatText: "취침 알람", isOn: true),
        Alarm(id: .init(), hour: 21, minute: 0, repeatText: "취침 알람", isOn: true),
        Alarm(id: .init(), hour: 7, minute: 10, repeatText: "알람, 주중", isOn: true),
        Alarm(id: .init(), hour: 8, minute: 30, repeatText: "운동 알람", isOn: false),
        Alarm(id: .init(), hour: 21, minute: 0, repeatText: "취침 알람", isOn: true)
    ]
}


final class AlarmViewController: BaseViewController {

    private let alarmView = AlarmView()
    private var alarms: [Alarm] = Alarm.mockList


    override func loadView() {
        view = alarmView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = CustomUIBarButtonItem(type: .edit(action: {
            print("EDIT")
        }))
        alarmView.tableView.dataSource = self
        alarmView.tableView.delegate = self
    }

    override func setStyles() {

    }

    override func setLayout() {
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
        let h = String(format: "%02d:%02d", alarm.hour, alarm.minute)
        let amPm = alarm.hour < 12 ? "AM" : "PM"
        cell.configure(time: h, amPm: amPm, detail: alarm.repeatText, isOn: alarm.isOn)
        return cell

    }

}

extension AlarmViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
      let header = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: AlarmTableViewHeaderCell.className
      )
      // 버튼 액션 연결
//      header.addButton.addTarget(
//        self, action: #selector(didTapAddAlarm), for: .touchUpInside
//      )
      return header
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
      return 320  // 컨텐츠 전부 보여줄 높이
    }
}
