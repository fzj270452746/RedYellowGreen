//
//  ToastFlare.swift
//  Lightweight inline toast banner.
//

import UIKit

final class ToastFlare {

    static func waft(_ message: String, on host: UIView) {
        let chip = PaddingLabel()
        chip.text = message
        chip.textColor = .white
        chip.textAlignment = .center
        chip.font = GlyphScribe.bold(CanvasMetric.scaled(13))
        chip.backgroundColor = UIColor.black.withAlphaComponent(0.78)
        chip.layer.cornerRadius = 14
        chip.clipsToBounds = true
        chip.alpha = 0
        chip.translatesAutoresizingMaskIntoConstraints = false
        host.addSubview(chip)
        NSLayoutConstraint.activate([
            chip.centerXAnchor.constraint(equalTo: host.centerXAnchor),
            chip.bottomAnchor.constraint(equalTo: host.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            chip.leadingAnchor.constraint(greaterThanOrEqualTo: host.leadingAnchor, constant: 24),
            chip.trailingAnchor.constraint(lessThanOrEqualTo: host.trailingAnchor, constant: -24)
        ])
        UIView.animate(withDuration: 0.22, animations: { chip.alpha = 1 })
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            UIView.animate(withDuration: 0.32, animations: { chip.alpha = 0 }) { _ in
                chip.removeFromSuperview()
            }
        }
    }
}

final class PaddingLabel: UILabel {
    var insets = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let s = super.intrinsicContentSize
        return CGSize(width: s.width + insets.left + insets.right,
                      height: s.height + insets.top + insets.bottom)
    }
}
