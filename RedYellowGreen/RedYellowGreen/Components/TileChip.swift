//
//  TileChip.swift
//  Renders a single mahjong tile with optional colored backing.
//

import UIKit

final class TileChip: UIControl {

    private let backing = UIView()
    private let artwork = UIImageView()
    private let halo = UIView()

    var blueprint: TileBlueprint? {
        didSet { refreshArt() }
    }

    var backingTint: BeaconHue? {
        didSet { refreshTint() }
    }

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) { nil }

    private func configure() {
        layer.cornerRadius = CanvasMetric.corner(12)
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.30
        layer.shadowRadius = 8
        layer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundColor = .clear

        backing.backgroundColor = HuePantry.chalk
        backing.layer.cornerRadius = CanvasMetric.corner(12)
        backing.layer.cornerCurve = .continuous
        backing.layer.borderWidth = 1.2
        backing.layer.borderColor = UIColor.white.withAlphaComponent(0.18).cgColor
        backing.isUserInteractionEnabled = false
        backing.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backing)

        halo.backgroundColor = .clear
        halo.layer.cornerRadius = CanvasMetric.corner(12)
        halo.layer.cornerCurve = .continuous
        halo.layer.borderWidth = 0
        halo.isUserInteractionEnabled = false
        halo.translatesAutoresizingMaskIntoConstraints = false
        addSubview(halo)

        artwork.contentMode = .scaleAspectFit
        artwork.isUserInteractionEnabled = false
        artwork.translatesAutoresizingMaskIntoConstraints = false
        addSubview(artwork)

        NSLayoutConstraint.activate([
            backing.topAnchor.constraint(equalTo: topAnchor),
            backing.leadingAnchor.constraint(equalTo: leadingAnchor),
            backing.trailingAnchor.constraint(equalTo: trailingAnchor),
            backing.bottomAnchor.constraint(equalTo: bottomAnchor),

            halo.topAnchor.constraint(equalTo: topAnchor),
            halo.leadingAnchor.constraint(equalTo: leadingAnchor),
            halo.trailingAnchor.constraint(equalTo: trailingAnchor),
            halo.bottomAnchor.constraint(equalTo: bottomAnchor),

            artwork.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            artwork.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            artwork.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
            artwork.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
        ])

        addTarget(self, action: #selector(touchedDown), for: .touchDown)
        addTarget(self, action: #selector(touchedUp), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
    }

    private func refreshArt() {
        guard let bp = blueprint else { artwork.image = nil; return }
        artwork.image = UIImage(named: bp.artworkName)
    }

    private func refreshTint() {
        guard let tone = backingTint else {
            backing.backgroundColor = HuePantry.chalk
            halo.layer.borderWidth = 0
            return
        }
        backing.backgroundColor = tone.bulbSoft.withAlphaComponent(0.85)
        halo.layer.borderWidth = 2
        halo.layer.borderColor = tone.bulb.cgColor
    }

    func flashCorrect() {
        let glow = UIView(frame: bounds)
        glow.layer.cornerRadius = CanvasMetric.corner(12)
        glow.backgroundColor = HuePantry.verdant.withAlphaComponent(0.6)
        glow.alpha = 0
        glow.isUserInteractionEnabled = false
        addSubview(glow)
        UIView.animate(withDuration: 0.15, animations: {
            glow.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
        }, completion: { _ in
            UIView.animate(withDuration: 0.22, animations: {
                glow.alpha = 0
                self.transform = .identity
            }, completion: { _ in
                glow.removeFromSuperview()
            })
        })
    }

    func flashWrong() {
        let glow = UIView(frame: bounds)
        glow.tag = 7331
        glow.layer.cornerRadius = CanvasMetric.corner(12)
        glow.backgroundColor = HuePantry.cinnabar.withAlphaComponent(0.7)
        glow.alpha = 0
        glow.isUserInteractionEnabled = false
        addSubview(glow)
        UIView.animate(withDuration: 0.18, animations: {
            glow.alpha = 1
        })
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.values = [-12, 12, -8, 8, -4, 4, 0]
        shake.duration = 0.42
        layer.add(shake, forKey: "shake")
    }

    func wipeOverlays() {
        layer.removeAllAnimations()
        transform = .identity
        for sub in subviews where sub.tag == 7331 {
            sub.removeFromSuperview()
        }
    }

    @objc private func touchedDown() {
        UIView.animate(withDuration: 0.10) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    @objc private func touchedUp() {
        UIView.animate(withDuration: 0.18) {
            self.transform = .identity
        }
    }
}
