//
//  GlossButton.swift
//  Custom rounded button with gradient and bounce feedback.
//

import UIKit

final class GlossButton: UIControl {

    private let backdrop = GradientPlate()
    private let captionLabel = UILabel()
    private let iconView = UIImageView()
    private var spacing: CGFloat = 0

    var caption: String = "" {
        didSet { captionLabel.text = caption }
    }

    var glyph: UIImage? {
        didSet {
            iconView.image = glyph
            iconView.isHidden = glyph == nil
        }
    }

    init(tint: TintFlavor = .royal) {
        super.init(frame: .zero)
        configure()
        applyTint(tint)
    }

    required init?(coder: NSCoder) { nil }

    func applyTint(_ tint: TintFlavor) {
        backdrop.palette = HuePantry.gradient(for: tint)
    }

    private func configure() {
        layer.cornerRadius = CanvasMetric.corner(18)
        layer.cornerCurve = .continuous
        clipsToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.32
        layer.shadowOffset = CGSize(width: 0, height: 6)
        layer.shadowRadius = 14

        backdrop.layer.cornerRadius = CanvasMetric.corner(18)
        backdrop.layer.cornerCurve = .continuous
        backdrop.clipsToBounds = true
        backdrop.isUserInteractionEnabled = false
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backdrop)

        captionLabel.font = GlyphScribe.heavy(CanvasMetric.scaled(17))
        captionLabel.textColor = .white
        captionLabel.textAlignment = .center
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(captionLabel)

        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconView.isHidden = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: bottomAnchor),
            backdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: trailingAnchor),

            iconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(22)),
            iconView.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(22)),

            captionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            captionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            captionLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            captionLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])

        addTarget(self, action: #selector(touchedDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchedUp), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
    }

    @objc private func touchedDown() {
        UIView.animate(withDuration: 0.12) { self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96) }
    }

    @objc private func touchedUp() {
        UIView.animate(withDuration: 0.18,
                       delay: 0,
                       usingSpringWithDamping: 0.55,
                       initialSpringVelocity: 0.4) {
            self.transform = .identity
        }
    }
}
