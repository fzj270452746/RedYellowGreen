//
//  HudPanel.swift
//  Top scoreboard with score and best.
//

import UIKit

final class HudPanel: UIView {

    private let scoreCaption = UILabel()
    private let scoreNumber = UILabel()
    private let bestCaption = UILabel()
    private let bestNumber = UILabel()

    var score: Int = 0 {
        didSet {
            UIView.transition(with: scoreNumber, duration: 0.18, options: .transitionCrossDissolve) {
                self.scoreNumber.text = "\(self.score)"
            }
        }
    }

    var best: Int = 0 {
        didSet { bestNumber.text = "\(best)" }
    }

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) { nil }

    private func configure() {
        backgroundColor = UIColor.black.withAlphaComponent(0.30)
        layer.cornerRadius = CanvasMetric.corner(20)
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.10).cgColor

        scoreCaption.text = "SCORE"
        scoreCaption.font = GlyphScribe.medium(CanvasMetric.scaled(11))
        scoreCaption.textColor = HuePantry.mute
        scoreCaption.textAlignment = .left

        scoreNumber.text = "0"
        scoreNumber.font = GlyphScribe.heavy(CanvasMetric.scaled(28))
        scoreNumber.textColor = HuePantry.chalk
        scoreNumber.textAlignment = .left

        bestCaption.text = "BEST"
        bestCaption.font = GlyphScribe.medium(CanvasMetric.scaled(11))
        bestCaption.textColor = HuePantry.mute
        bestCaption.textAlignment = .right

        bestNumber.text = "0"
        bestNumber.font = GlyphScribe.heavy(CanvasMetric.scaled(22))
        bestNumber.textColor = HuePantry.saffron
        bestNumber.textAlignment = .right

        let leftStack = UIStackView(arrangedSubviews: [scoreCaption, scoreNumber])
        leftStack.axis = .vertical
        leftStack.spacing = 2
        leftStack.alignment = .leading

        let rightStack = UIStackView(arrangedSubviews: [bestCaption, bestNumber])
        rightStack.axis = .vertical
        rightStack.spacing = 2
        rightStack.alignment = .trailing

        let outer = UIStackView(arrangedSubviews: [leftStack, rightStack])
        outer.axis = .horizontal
        outer.distribution = .fillEqually
        outer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(outer)

        NSLayoutConstraint.activate([
            outer.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            outer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            outer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            outer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
    }
}
