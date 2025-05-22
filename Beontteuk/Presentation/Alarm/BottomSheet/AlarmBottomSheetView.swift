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

final class AlarmBottomSheetView: BaseView {

    private let timePicker = UIDatePicker().then {
        $0.preferredDatePickerStyle = .wheels
        $0.datePickerMode = .time
        $0.minuteInterval = 1
        $0.locale = Locale(identifier: "ko_KR")
        // 다크모드 전환시에도 글자 색 고정
        $0.setValue(UIColor.neutral1000, forKeyPath: "textColor")
    }

    // TODO: ViewModel 작업시 private로 변경하기
    let tableView = UITableView(frame: .zero, style: .insetGrouped).then {
        $0.register(AlarmBottomSheetTableViewCell.self, forCellReuseIdentifier: AlarmBottomSheetTableViewCell.className)
        $0.isScrollEnabled = false
        $0.rowHeight = UITableView.automaticDimension
        $0.backgroundColor = .clear
    }

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
}
