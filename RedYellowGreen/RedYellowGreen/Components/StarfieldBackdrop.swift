//
//  StarfieldBackdrop.swift
//  Decorative animated dots layered behind UI.
//

import UIKit

final class StarfieldBackdrop: UIView {

    private var motes: [CALayer] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) { nil }

    override func layoutSubviews() {
        super.layoutSubviews()
        if motes.isEmpty {
            scatter()
        }
    }

    private func scatter() {
        let count = CanvasMetric.isRoomyDevice ? 36 : 22
        for _ in 0..<count {
            let dot = CALayer()
            let radius = CGFloat.random(in: 1.2...3.6)
            dot.bounds = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
            dot.position = CGPoint(x: .random(in: 0...bounds.width),
                                   y: .random(in: 0...bounds.height))
            dot.cornerRadius = radius
            let palette = [HuePantry.cinnabarSoft, HuePantry.saffronSoft, HuePantry.verdantSoft, HuePantry.lilacAccent]
            dot.backgroundColor = palette.randomElement()?.withAlphaComponent(0.55).cgColor
            dot.shadowColor = dot.backgroundColor
            dot.shadowRadius = 8
            dot.shadowOpacity = 0.8
            dot.shadowOffset = .zero
            layer.addSublayer(dot)
            motes.append(dot)
            twinkle(dot)
        }
    }

    private func twinkle(_ dot: CALayer) {
        let anim = CABasicAnimation(keyPath: "opacity")
        anim.fromValue = 0.25
        anim.toValue = 1.0
        anim.duration = TimeInterval.random(in: 1.4...3.6)
        anim.autoreverses = true
        anim.repeatCount = .infinity
        anim.timeOffset = TimeInterval.random(in: 0...2)
        dot.add(anim, forKey: "twinkle")
    }
}
