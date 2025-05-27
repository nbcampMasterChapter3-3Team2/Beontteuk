//
//  AlarmBottomSheetView.swift
//  Beontteuk
//
//  Created by yimkeul on 5/21/25.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

final class AlarmBottomSheetView: BaseView {

    var dateChanged: ControlProperty<Date> { timePicker.rx.date }

    private let timePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .time
        $0.minuteInterval = 1
        $0.locale = Locale.autoupdatingCurrent
        // 다크모드 전환시에도 글자 색 고정
        $0.setValue(UIColor.neutral1000, forKeyPath: "textColor")
    }

    private let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(BottomSheetTableViewCell.self, forCellReuseIdentifier: BottomSheetTableViewCell.className)
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "DeleteCell")
        $0.isScrollEnabled = false
        $0.rowHeight = UITableView.automaticDimension
        $0.backgroundColor = .clear
    }

    private let testButton = AddButton(type: .alarm)

    override func setLayout() {
        addSubviews(timePicker, tableView)
        timePicker.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    func getTableView() -> UITableView {
        return tableView
    }
    func getTimePicker() -> UIDatePicker {
        return timePicker
    }

}
