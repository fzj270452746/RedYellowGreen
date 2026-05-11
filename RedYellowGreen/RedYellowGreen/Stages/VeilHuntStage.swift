//
//  VeilHuntStage.swift
//  Mode 4: same suit-rule, but the lantern goes dark before each shift.
//  Tap during the veil and the run ends.
//

import UIKit

final class VeilHuntStage: ArenaStage {

    override var modeKey: String { "Veil" }
    override var modeTitle: String { "Lantern Veil" }

    private var veiled: Bool = false
    private var veilTimer: Timer?
    private let warning = WarningStripe()

    override func viewDidLoad() {
        super.viewDidLoad()
        warning.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(warning)
        NSLayoutConstraint.activate([
            warning.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            warning.topAnchor.constraint(equalTo: beacon.bottomAnchor, constant: -CanvasMetric.scaled(8)),
            warning.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(22)),
            warning.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(120))
        ])
        warning.alpha = 0
    }

    override func showStarter() {
        rule = RuleAlmanac.freshDeal()
        absorbRule()
        board.reshuffleArtwork(animated: false)
        let prompt = PromptCurtain(title: modeTitle,
                                    body: assemblePrimer())
        let go = GlossButton(tint: .ember)
        go.caption = "START"
        go.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(48)).isActive = true
        go.addAction(UIAction { [weak self, weak prompt] _ in
            prompt?.dismiss { self?.ignite() }
        }, for: .touchUpInside)
        prompt.actionStack.addArrangedSubview(go)
        prompt.raise(over: view)
    }

    private func assemblePrimer() -> String {
        let lines = rule.summaryLines().map { "\($0.0.caption) → \($0.1.caption)" }
        return ["Match the lit color to its suit — but the lantern dims before every shift.",
                "Tap during a dim, and the run ends.",
                "",
                lines.joined(separator: "\n")].joined(separator: "\n")
    }

    override func cadenceDidShift(to hue: BeaconHue, holdFor seconds: TimeInterval) {
        veilTimer?.invalidate()
        let veilSpan = min(2.0, max(0.9, 0.9 + Double(score) / 240.0))
        veiled = true
        beacon.dim()
        showWarning()
        veilTimer = Timer.scheduledTimer(withTimeInterval: veilSpan, repeats: false) { [weak self] _ in
            self?.lift(to: hue)
        }
    }

    private func lift(to hue: BeaconHue) {
        veiled = false
        hideWarning()
        beacon.swing(to: hue)
    }

    override func togglePause() {
        super.togglePause()
        if paused {
            veilTimer?.invalidate()
            veilTimer = nil
        }
    }

    override func askQuit() {
        veilTimer?.invalidate()
        veilTimer = nil
        super.askQuit()
    }

    override func showFinish() {
        veilTimer?.invalidate()
        veilTimer = nil
        super.showFinish()
    }

    override func restart() {
        veilTimer?.invalidate()
        veilTimer = nil
        veiled = false
        hideWarning()
        super.restart()
    }

    override func lattice(_ board: LatticeBoard, didTap spot: LatticeSpot, chip: TileChip) {
        guard !paused, let bp = chip.blueprint else { return }
        if veiled {
            if VaultStash.hapticsOn { PulseTactile.scold() }
            ToastFlare.waft("Tapped during veil", on: view)
            bust(on: chip)
            return
        }
        let needed = rule.required(for: coordinator.currentHue)
        if bp.suit == needed {
            gainPoint(on: chip)
            board.reshuffleArtwork(animated: true)
        } else {
            bust(on: chip)
        }
    }

    private func showWarning() {
        UIView.animate(withDuration: 0.18) {
            self.warning.alpha = 1
            self.warning.transform = .identity
        }
    }

    private func hideWarning() {
        UIView.animate(withDuration: 0.22) {
            self.warning.alpha = 0
            self.warning.transform = CGAffineTransform(translationX: 0, y: -4)
        }
    }
}

final class WarningStripe: UIView {

    private let label = UILabel()

    init() {
        super.init(frame: .zero)
        backgroundColor = HuePantry.cinnabar.withAlphaComponent(0.92)
        layer.cornerRadius = CanvasMetric.corner(11)
        layer.cornerCurve = .continuous
        layer.shadowColor = HuePantry.cinnabar.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowRadius = 10
        layer.shadowOffset = .zero

        label.text = "DON'T TAP"
        label.font = GlyphScribe.heavy(CanvasMetric.scaled(11))
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }
}
