//
//  StopWatchViewModel.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

struct LapTestModel {
    var lap: String
    var lappedTime: String
    var timeInterval: String
}

final class StopWatchViewModel {

    let items: [LapTestModel] = [
        LapTestModel(lap: "랩 1", lappedTime: "00:00.48", timeInterval: "00:00.48"),
        LapTestModel(lap: "랩 2", lappedTime: "00:00.51", timeInterval: "00:00.03"),
        LapTestModel(lap: "랩 3", lappedTime: "00:01.01", timeInterval: "00:00.10"),
        LapTestModel(lap: "랩 4", lappedTime: "00:01.32", timeInterval: "00:00.31"),
        LapTestModel(lap: "랩 5", lappedTime: "00:01.48", timeInterval: "00:00.16"),
        LapTestModel(lap: "랩 6", lappedTime: "00:03.51", timeInterval: "00:02.03"),
        LapTestModel(lap: "랩 7", lappedTime: "00:04.31", timeInterval: "00:00.40"),
    ]
}
