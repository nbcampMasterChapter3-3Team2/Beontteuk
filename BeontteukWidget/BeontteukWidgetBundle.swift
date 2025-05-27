//
//  BeontteukWidgetBundle.swift
//  BeontteukWidget
//
//  Created by 곽다은 on 5/28/25.
//

import WidgetKit
import SwiftUI

@main
struct BeontteukWidgetBundle: WidgetBundle {
    var body: some Widget {
        BeontteukWidget()
        BeontteukWidgetControl()
        BeontteukWidgetLiveActivity()
    }
}
