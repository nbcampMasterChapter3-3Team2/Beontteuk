//
//  EmptyExtension.swift
//  Alarm
//
//  Created by 백래훈 on 5/20/25.
//

import UIKit

extension NSObject {
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
    
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
}

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }

    func applyGradient() {
        let colors:[UIColor] = [.background200, .background500]
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 1, y: 1)
        let locations: [NSNumber]? = nil

        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map(\.cgColor)
        gradient.locations = locations
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint

        layer.insertSublayer(gradient, at: 0)
    }

    /// layoutSubviews 등에서 크기가 바뀔 때마다 다시 적용할 수 있게
    func refreshGradient() {
        layer.sublayers?
            .compactMap { $0 as? CAGradientLayer }
            .forEach { $0.frame = bounds }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
