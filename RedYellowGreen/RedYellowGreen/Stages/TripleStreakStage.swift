//
//  TripleStreakStage.swift
//  Mode 3: chain three matching-tinted taps before the timer empties.
//

import UIKit

final class TripleStreakStage: ArenaStage {

    override var modeKey: String { "Streak" }
    override var modeTitle: String { "Triple Streak" }

    private let meter = StreakMeter()
    private var deadline: Timer?
    private var roundHue: BeaconHue = .crimson

    override func viewDidLoad() {
        super.viewDidLoad()
        ruleStrip.isHidden = true
        meter.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(meter)
        NSLayoutConstraint.activate([
            meter.topAnchor.constraint(equalTo: beacon.bottomAnchor, constant: 14),
            meter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            meter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            meter.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(56))
        ])
    }

    override func showStarter() {
        meter.reset()
        board.reshuffleArtwork(animated: false)
        board.reshuffleTints(animated: false)
        let prompt = PromptCurtain(title: modeTitle,
                                    body: "When the lantern lights, chain THREE taps on tiles whose backing matches it — before the bar empties. Each chain scores +30. One miss or timeout ends the run.")
        let go = GlossButton(tint: .royal)
        go.caption = "START"
        go.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(48)).isActive = true
        go.addAction(UIAction { [weak self, weak prompt] _ in
            prompt?.dismiss { self?.ignite() }
        }, for: .touchUpInside)
        prompt.actionStack.addArrangedSubview(go)
        prompt.raise(over: view)
    }

    override func cadenceDidShift(to hue: BeaconHue, holdFor seconds: TimeInterval) {
        super.cadenceDidShift(to: hue, holdFor: seconds)
        roundHue = hue
        meter.clearPips()
        let window = max(2.4, 4.6 - Double(score) / 220.0)
        meter.drainFromFull(over: window, hue: hue.bulb)
        deadline?.invalidate()
        deadline = Timer.scheduledTimer(withTimeInterval: window, repeats: false) { [weak self] _ in
            self?.timeoutBust()
        }
    }

    override func ignite() {
        super.ignite()
    }

    override func togglePause() {
        super.togglePause()
        if paused {
            deadline?.invalidate()
            deadline = nil
            meter.freeze()
        }
    }

    override func askQuit() {
        deadline?.invalidate()
        deadline = nil
        super.askQuit()
    }

    override func showFinish() {
        deadline?.invalidate()
        deadline = nil
        super.showFinish()
    }

    override func restart() {
        deadline?.invalidate()
        deadline = nil
        meter.reset()
        super.restart()
        board.reshuffleArtwork(animated: false)
        board.reshuffleTints(animated: false)
    }

    override func lattice(_ board: LatticeBoard, didTap spot: LatticeSpot, chip: TileChip) {
        guard !paused, let tone = chip.backingTint else { return }
        if tone == roundHue {
            meter.bumpStreak(filledHue: roundHue.bulb)
            chip.flashCorrect()
            if VaultStash.hapticsOn { PulseTactile.tap() }
            chip.backingTint = BeaconHue.allCases.randomElement()
            if meter.streak >= 3 {
                deadline?.invalidate()
                deadline = nil
                score += 30
                hud.score = score
                meter.clearPips()
                board.reshuffleTints(animated: true)
                coordinator.tighten(by: score)
                if VaultStash.hapticsOn { PulseTactile.cheer() }
            }
        } else {
            deadline?.invalidate()
            deadline = nil
            bust(on: chip)
        }
    }

    private func timeoutBust() {
        guard !paused else { return }
        coordinator.extinguish()
        beacon.dim()
        if VaultStash.hapticsOn { PulseTactile.scold() }
        ToastFlare.waft("Too slow", on: view)
        showFinish()
    }
}
