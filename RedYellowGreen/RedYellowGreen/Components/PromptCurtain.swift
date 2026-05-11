//
//  PromptCurtain.swift
//  Custom semi-transparent modal container with content card.
//

import UIKit

final class PromptCurtain: UIView {

    let card = UIView()
    let titleLabel = UILabel()
    let bodyLabel = UILabel()
    let actionStack = UIStackView()
    private let backdropMask = UIView()

    init(title: String, body: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor.black.withAlphaComponent(0.55)
        configure()
        titleLabel.text = title
        bodyLabel.text = body
    }

    required init?(coder: NSCoder) { nil }

    private func configure() {
        backdropMask.backgroundColor = .clear
        backdropMask.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backdropMask)

        card.backgroundColor = HuePantry.abyssShade
        card.layer.cornerRadius = CanvasMetric.corner(24)
        card.layer.cornerCurve = .continuous
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.10).cgColor
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.45
        card.layer.shadowRadius = 24
        card.layer.shadowOffset = CGSize(width: 0, height: 12)
        card.translatesAutoresizingMaskIntoConstraints = false
        addSubview(card)

        let strip = GradientPlate()
        strip.palette = [HuePantry.cinnabarSoft, HuePantry.saffron, HuePantry.verdantSoft]
        strip.slope = (CGPoint(x: 0, y: 0.5), CGPoint(x: 1, y: 0.5))
        strip.layer.cornerRadius = 3
        strip.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(strip)

        titleLabel.font = GlyphScribe.heavy(CanvasMetric.scaled(22))
        titleLabel.textColor = HuePantry.chalk
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center

        bodyLabel.font = GlyphScribe.regular(CanvasMetric.scaled(15))
        bodyLabel.textColor = HuePantry.mute
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center

        actionStack.axis = .vertical
        actionStack.spacing = CanvasMetric.scaled(10)
        actionStack.distribution = .fillEqually

        let column = UIStackView(arrangedSubviews: [titleLabel, bodyLabel, actionStack])
        column.axis = .vertical
        column.spacing = CanvasMetric.scaled(14)
        column.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(column)

        NSLayoutConstraint.activate([
            backdropMask.topAnchor.constraint(equalTo: topAnchor),
            backdropMask.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdropMask.trailingAnchor.constraint(equalTo: trailingAnchor),
            backdropMask.bottomAnchor.constraint(equalTo: bottomAnchor),

            card.centerXAnchor.constraint(equalTo: centerXAnchor),
            card.centerYAnchor.constraint(equalTo: centerYAnchor),
            card.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -24),
            card.widthAnchor.constraint(lessThanOrEqualToConstant: 460),
            card.widthAnchor.constraint(greaterThanOrEqualToConstant: 280),

            strip.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            strip.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            strip.widthAnchor.constraint(equalToConstant: 60),
            strip.heightAnchor.constraint(equalToConstant: 6),

            column.topAnchor.constraint(equalTo: strip.bottomAnchor, constant: 22),
            column.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 24),
            column.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -24),
            column.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -22)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(backdropTapped))
        backdropMask.addGestureRecognizer(tap)
    }

    @objc private func backdropTapped() {
        // override hook for outer code
    }

    func raise(over host: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        host.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: host.topAnchor),
            leadingAnchor.constraint(equalTo: host.leadingAnchor),
            trailingAnchor.constraint(equalTo: host.trailingAnchor),
            bottomAnchor.constraint(equalTo: host.bottomAnchor)
        ])
        alpha = 0
        card.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.32,
                       delay: 0,
                       usingSpringWithDamping: 0.78,
                       initialSpringVelocity: 0.4,
                       options: .curveEaseOut) {
            self.alpha = 1
            self.card.transform = .identity
        }
    }

    func dismiss(_ done: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.22, animations: {
            self.alpha = 0
            self.card.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: { _ in
            self.removeFromSuperview()
            done?()
        })
    }
}
