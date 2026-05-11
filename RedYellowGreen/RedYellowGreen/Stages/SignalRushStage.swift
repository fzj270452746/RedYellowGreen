//
//  SignalRushStage.swift
//  Mode 2: tile artwork is fixed, but tile backings cycle colors over time.
//

import UIKit

final class SignalRushStage: ArenaStage {

    override var modeKey: String { "Traffic" }
    override var modeTitle: String { "Traffic Lights" }

    private var tintTimer: Timer?

    override func showStarter() {
        ruleStrip.isHidden = true
        board.reshuffleArtwork(animated: false)
        board.reshuffleTints(animated: false)
        let prompt = PromptCurtain(title: modeTitle,
                                    body: "Tap only the tiles whose backing matches the current beacon. Backings change over time. Faster as you score!")
        let go = GlossButton(tint: .jade)
        go.caption = "START"
        go.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(48)).isActive = true
        go.addAction(UIAction { [weak self, weak prompt] _ in
            prompt?.dismiss { self?.ignite() }
        }, for: .touchUpInside)
        prompt.actionStack.addArrangedSubview(go)
        prompt.raise(over: view)
    }

    override func ignite() {
        super.ignite()
        scheduleTintTick()
    }

    override func togglePause() {
        super.togglePause()
        if paused {
            tintTimer?.invalidate()
            tintTimer = nil
        } else {
            scheduleTintTick()
        }
    }

    override func askQuit() {
        super.askQuit()
        tintTimer?.invalidate()
        tintTimer = nil
    }

    override func showFinish() {
        tintTimer?.invalidate()
        tintTimer = nil
        super.showFinish()
    }

    override func restart() {
        tintTimer?.invalidate()
        tintTimer = nil
        super.restart()
        board.reshuffleArtwork(animated: false)
        board.reshuffleTints(animated: false)
    }

    private func scheduleTintTick() {
        tintTimer?.invalidate()
        let interval = max(0.6, 2.4 - Double(score) / 250.0)
        tintTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.board.reshuffleTints(animated: true)
        }
    }

    override func lattice(_ board: LatticeBoard, didTap spot: LatticeSpot, chip: TileChip) {
        guard !paused, let tone = chip.backingTint else { return }
        if tone == coordinator.currentHue {
            gainPoint(on: chip)
            chip.backingTint = BeaconHue.allCases.randomElement()
            scheduleTintTick()
        } else {
            bust(on: chip)
        }
    }
}
