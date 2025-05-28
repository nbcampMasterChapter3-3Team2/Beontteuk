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
        let colors: [UIColor] = [.background200, .background500]
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

    /// View의 Layer에 그림자를 적용합니다.
    ///
    /// 이 메서드를 호출하는 것만으로는 shadowPath가 적용되지 않아, 매 프레임마다 shadowPath를 결정하게 되어 GPU 부하가 커지기 때문에 View의 bounds가 결정된 후 path를 설정해주어야 합니다. 즉, layoutSubViews에서 updateShadowPath()를 꼭 호출해주어야 합니다. 예시:
    ///
    /// ```swift
    /// let myView: UIView() = {
    ///     let view = UIView()
    ///     view.setShadow(type: .large)
    ///     return view
    /// }()
    ///
    /// override func layoutSubviews() {
    ///     super.layoutSubviews()
    ///     myView.updateShadowPath()
    /// }
    /// ```
    func setShadow(type: ShadowSize) {
        layer.shadowColor = UIColor.neutral1000.cgColor
        layer.shadowRadius = 5
        layer.shadowOffset = type.offset
        layer.shadowOpacity = 0.25
    }

    func updateShadowPath() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        }
    }

    enum ShadowSize {
        case large
        case small

        var offset: CGSize {
            switch self {
            case .large: .init(width: 2, height: 5)
            case .small: .init(width: 1, height: 2.5)
            }
        }
    }
}

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}

extension Locale {
    var uses24HourClock: Bool {
        let format = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: self) ?? ""
        return !format.contains("a")
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result ?? self
    }
}

extension UIFont {
    static func lightFont() -> UIFont {
        return UIFont.systemFont(ofSize: 55, weight: .light)
    }
    static func labelLightFont() -> UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .light)
    }
    static func ampmLightFont() -> UIFont {
        return UIFont.systemFont(ofSize: 25, weight: .light)
    }
}

extension Date {
    func convert(to timeZone: TimeZone) -> Date {
        let currentOffset = TimeZone.current.secondsFromGMT(for: self)
        let targetOffset = timeZone.secondsFromGMT(for: self)
        let timeInterval = TimeInterval(targetOffset - currentOffset)
        return addingTimeInterval(timeInterval)
    }
}

extension Double {
    func convertToTimeString() -> String {
        let totalSeconds = Int(self)
            let h = totalSeconds / 3600
            let m = (totalSeconds % 3600) / 60
            let s = totalSeconds % 60

            if h > 0 {
                return String(format: "%d:%02d:%02d", h, m, s)
            } else {
                return String(format: "%d:%02d", m, s)
            }
    }
}
