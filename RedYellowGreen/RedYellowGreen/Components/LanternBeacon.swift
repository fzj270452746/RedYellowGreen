//
//  LanternBeacon.swift
//  Animated traffic lantern shown above the board.
//

import UIKit

final class LanternBeacon: UIView {

    private let crimsonOrb = OrbBulb(tone: .crimson)
    private let amberOrb = OrbBulb(tone: .amber)
    private let jadeOrb = OrbBulb(tone: .jade)

    private(set) var glowing: BeaconHue = .crimson

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) { nil }

    func swing(to hue: BeaconHue) {
        glowing = hue
        crimsonOrb.lit = (hue == .crimson)
        amberOrb.lit = (hue == .amber)
        jadeOrb.lit = (hue == .jade)
        UIView.animate(withDuration: 0.18) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        }
    }

    func dim() {
        crimsonOrb.lit = false
        amberOrb.lit = false
        jadeOrb.lit = false
        UIView.animate(withDuration: 0.22) {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.78)
        }
    }

    private func configure() {
        backgroundColor = UIColor.black.withAlphaComponent(0.32)
        layer.cornerRadius = CanvasMetric.corner(28)
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
        layer.borderWidth = 1

        let stack = UIStackView(arrangedSubviews: [crimsonOrb, amberOrb, jadeOrb])
        stack.axis = .horizontal
        stack.spacing = CanvasMetric.scaled(14)
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: CanvasMetric.scaled(20)),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -CanvasMetric.scaled(20))
        ])
    }
}

final class OrbBulb: UIView {

    private let tone: BeaconHue
    private let halo = UIView()

    var lit: Bool = false {
        didSet { animateBeam() }
    }

    init(tone: BeaconHue) {
        self.tone = tone
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) { nil }

    override var intrinsicContentSize: CGSize {
        let size = CanvasMetric.scaled(38)
        return CGSize(width: size, height: size)
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        let dim = CanvasMetric.scaled(38)
        widthAnchor.constraint(equalToConstant: dim).isActive = true
        heightAnchor.constraint(equalToConstant: dim).isActive = true

        halo.backgroundColor = tone.bulb.withAlphaComponent(0.25)
        halo.layer.cornerRadius = dim / 2
        halo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(halo)
        NSLayoutConstraint.activate([
            halo.topAnchor.constraint(equalTo: topAnchor),
            halo.leadingAnchor.constraint(equalTo: leadingAnchor),
            halo.trailingAnchor.constraint(equalTo: trailingAnchor),
            halo.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func animateBeam() {
        UIView.animate(withDuration: 0.28) {
            self.halo.backgroundColor = self.lit
                ? self.tone.bulb
                : self.tone.bulb.withAlphaComponent(0.18)
            self.halo.transform = self.lit
                ? CGAffineTransform(scaleX: 1.15, y: 1.15)
                : .identity
        }
        if lit {
            halo.layer.shadowColor = tone.bulb.cgColor
            halo.layer.shadowOpacity = 0.95
            halo.layer.shadowRadius = 18
            halo.layer.shadowOffset = .zero
        } else {
            halo.layer.shadowOpacity = 0
        }
    }
}
