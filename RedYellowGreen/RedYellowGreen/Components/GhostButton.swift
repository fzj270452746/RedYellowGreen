//
//  GhostButton.swift
//  Outline style button.
//

import UIKit

final class GhostButton: UIControl {

    private let captionLabel = UILabel()
    private let halo = CAShapeLayer()

    var caption: String = "" {
        didSet { captionLabel.text = caption }
    }

    init(caption: String = "") {
        super.init(frame: .zero)
        self.caption = caption
        configure()
    }

    required init?(coder: NSCoder) { nil }

    private func configure() {
        layer.cornerRadius = CanvasMetric.corner(16)
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.white.withAlphaComponent(0.32).cgColor
        layer.borderWidth = 1.4
        backgroundColor = UIColor.white.withAlphaComponent(0.06)

        captionLabel.font = GlyphScribe.bold(CanvasMetric.scaled(15))
        captionLabel.textColor = HuePantry.chalk
        captionLabel.textAlignment = .center
        captionLabel.text = caption
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(captionLabel)

        NSLayoutConstraint.activate([
            captionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            captionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            captionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 12),
            captionLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -12)
        ])

        addTarget(self, action: #selector(touchedDown), for: .touchDown)
        addTarget(self, action: #selector(touchedUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func touchedDown() {
        UIView.animate(withDuration: 0.10) {
            self.alpha = 0.7
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }
    }

    @objc private func touchedUp() {
        UIView.animate(withDuration: 0.18) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}
