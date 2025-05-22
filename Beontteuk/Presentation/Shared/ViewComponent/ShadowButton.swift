//
//  ShadowButton.swift
//  Beontteuk
//
//  Created by yimkeul on 5/22/25.
//

import UIKit

final class ShadowButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        updateShadowPath()
    }
}

