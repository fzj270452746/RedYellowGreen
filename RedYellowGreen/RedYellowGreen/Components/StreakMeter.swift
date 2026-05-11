//
//  StreakMeter.swift
//  Combo counter and timer bar for Triple Streak mode.
//

import UIKit

final class StreakMeter: UIView {

    private let caption = UILabel()
    private let pips: [UIView] = [UIView(), UIView(), UIView()]
    private let trough = UIView()
    private let crest = UIView()
    private var crestWidth: NSLayoutConstraint?

    var goal: Int = 3
    private(set) var streak: Int = 0

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) { nil }

    private func configure() {
        backgroundColor = UIColor.black.withAlphaComponent(0.30)
        layer.cornerRadius = CanvasMetric.corner(18)
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.withAlphaComponent(0.10).cgColor

        caption.text = "STREAK"
        caption.font = GlyphScribe.medium(CanvasMetric.scaled(11))
        caption.textColor = HuePantry.mute
        caption.translatesAutoresizingMaskIntoConstraints = false
        addSubview(caption)

        let pipRow = UIStackView()
        pipRow.axis = .horizontal
        pipRow.spacing = 8
        pipRow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pipRow)
        for pip in pips {
            pip.backgroundColor = UIColor.white.withAlphaComponent(0.16)
            pip.layer.cornerRadius = 6
            pip.translatesAutoresizingMaskIntoConstraints = false
            pip.widthAnchor.constraint(equalToConstant: 18).isActive = true
            pip.heightAnchor.constraint(equalToConstant: 12).isActive = true
            pipRow.addArrangedSubview(pip)
        }

        trough.backgroundColor = UIColor.white.withAlphaComponent(0.10)
        trough.layer.cornerRadius = 4
        trough.translatesAutoresizingMaskIntoConstraints = false
        addSubview(trough)

        crest.backgroundColor = HuePantry.saffron
        crest.layer.cornerRadius = 4
        crest.translatesAutoresizingMaskIntoConstraints = false
        trough.addSubview(crest)
        crestWidth = crest.widthAnchor.constraint(equalTo: trough.widthAnchor, multiplier: 1)
        crestWidth?.isActive = true

        NSLayoutConstraint.activate([
            caption.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            caption.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),

            pipRow.centerYAnchor.constraint(equalTo: caption.centerYAnchor),
            pipRow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),

            trough.heightAnchor.constraint(equalToConstant: 8),
            trough.topAnchor.constraint(equalTo: caption.bottomAnchor, constant: 8),
            trough.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            trough.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            trough.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),

            crest.topAnchor.constraint(equalTo: trough.topAnchor),
            crest.bottomAnchor.constraint(equalTo: trough.bottomAnchor),
            crest.leadingAnchor.constraint(equalTo: trough.leadingAnchor)
        ])
    }

    func reset() {
        streak = 0
        for pip in pips {
            pip.backgroundColor = UIColor.white.withAlphaComponent(0.16)
        }
        repaintCrest(progress: 1, hue: HuePantry.saffron, animated: false)
    }

    func bumpStreak(filledHue: UIColor) {
        streak = min(goal, streak + 1)
        UIView.transition(with: pips[streak - 1], duration: 0.18, options: .transitionCrossDissolve) {
            self.pips[self.streak - 1].backgroundColor = filledHue
        }
    }

    func clearPips() {
        for pip in pips {
            UIView.transition(with: pip, duration: 0.16, options: .transitionCrossDissolve) {
                pip.backgroundColor = UIColor.white.withAlphaComponent(0.16)
            }
        }
        streak = 0
    }

    func drainFromFull(over duration: TimeInterval, hue: UIColor) {
        crest.layer.removeAllAnimations()
        crest.backgroundColor = hue
        crestWidth?.isActive = false
        crestWidth = crest.widthAnchor.constraint(equalTo: trough.widthAnchor, multiplier: 1)
        crestWidth?.isActive = true
        layoutIfNeeded()
        crestWidth?.isActive = false
        crestWidth = crest.widthAnchor.constraint(equalTo: trough.widthAnchor, multiplier: 0.001)
        crestWidth?.isActive = true
        UIView.animate(withDuration: duration, delay: 0, options: [.curveLinear]) {
            self.layoutIfNeeded()
        }
    }

    func freeze() {
        let presented = crest.layer.presentation()?.bounds.width ?? crest.bounds.width
        let parentWidth = trough.bounds.width
        let fraction = parentWidth > 0 ? presented / parentWidth : 0
        crest.layer.removeAllAnimations()
        crestWidth?.isActive = false
        crestWidth = crest.widthAnchor.constraint(equalTo: trough.widthAnchor, multiplier: max(0.001, fraction))
        crestWidth?.isActive = true
        layoutIfNeeded()
    }

    private func repaintCrest(progress: CGFloat, hue: UIColor, animated: Bool) {
        crestWidth?.isActive = false
        crestWidth = crest.widthAnchor.constraint(equalTo: trough.widthAnchor, multiplier: max(0.001, progress))
        crestWidth?.isActive = true
        crest.backgroundColor = hue
        if animated {
            UIView.animate(withDuration: 0.18) { self.layoutIfNeeded() }
        } else {
            layoutIfNeeded()
        }
    }
}
