//
//  RuleBoardlet.swift
//  Compact display of the active rule mapping.
//

import UIKit

final class RuleBoardlet: UIView {

    private let crimsonRow = RowChip(hue: .crimson)
    private let amberRow = RowChip(hue: .amber)
    private let jadeRow = RowChip(hue: .jade)

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) { nil }

    func absorb(_ rule: RuleAlmanac) {
        crimsonRow.suit = rule.crimson
        amberRow.suit = rule.amber
        jadeRow.suit = rule.jade
    }

    private func configure() {
        backgroundColor = UIColor.black.withAlphaComponent(0.30)
        layer.cornerRadius = CanvasMetric.corner(18)
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor

        let row = UIStackView(arrangedSubviews: [crimsonRow, amberRow, jadeRow])
        row.axis = .horizontal
        row.distribution = .fillEqually
        row.spacing = CanvasMetric.scaled(8)
        row.translatesAutoresizingMaskIntoConstraints = false
        addSubview(row)

        NSLayoutConstraint.activate([
            row.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            row.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            row.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            row.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}

final class RowChip: UIView {

    private let dot = UIView()
    private let suitLabel = UILabel()
    private let arrow = UILabel()

    var suit: SuitKind = .word {
        didSet { suitLabel.text = suit.caption.uppercased() }
    }

    init(hue: BeaconHue) {
        super.init(frame: .zero)
        configure(hue: hue)
    }

    required init?(coder: NSCoder) { nil }

    private func configure(hue: BeaconHue) {
        dot.backgroundColor = hue.bulb
        dot.layer.cornerRadius = 6
        dot.layer.shadowColor = hue.bulb.cgColor
        dot.layer.shadowRadius = 6
        dot.layer.shadowOpacity = 0.8
        dot.layer.shadowOffset = .zero
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.widthAnchor.constraint(equalToConstant: 12).isActive = true
        dot.heightAnchor.constraint(equalToConstant: 12).isActive = true

        arrow.text = "→"
        arrow.font = GlyphScribe.bold(CanvasMetric.scaled(11))
        arrow.textColor = HuePantry.mute

        suitLabel.font = GlyphScribe.heavy(CanvasMetric.scaled(11))
        suitLabel.textColor = HuePantry.chalk
        suitLabel.text = SuitKind.word.caption.uppercased()

        let stack = UIStackView(arrangedSubviews: [dot, arrow, suitLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
