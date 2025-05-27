//
//  BottomSheetSectionModel.swift
//  Beontteuk
//
//  Created by yimkeul on 5/27/25.
//

import Foundation
import RxDataSources

/// 테이블뷰의 섹션 아이템
enum BottomSheetItem {
    case option(BottomSheetTableOption)
    case delete
}

/// RxDataSources용 섹션 모델
struct BottomSheetSectionModel {
    var header: String?
    var items: [BottomSheetItem]
}

extension BottomSheetSectionModel: SectionModelType {
    typealias Item = BottomSheetItem

    init(original: BottomSheetSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
