//
//  ScholarMatchStage.swift
//  Mode 1: tap tile by suit, board reshuffles after each correct tap.
//

import UIKit

final class ScholarMatchStage: ArenaStage {

    override var modeKey: String { "RYG" }
    override var modeTitle: String { "Red Yellow Green" }

    override func showStarter() {
        rule = RuleAlmanac.freshDeal()
        absorbRule()
        board.reshuffleArtwork(animated: false)
        let prompt = PromptCurtain(title: modeTitle,
                                    body: assembleStarter())
        let go = GlossButton(tint: .crimson)
        go.caption = "START"
        go.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(48)).isActive = true
        go.addAction(UIAction { [weak self, weak prompt] _ in
            prompt?.dismiss { self?.ignite() }
        }, for: .touchUpInside)
        prompt.actionStack.addArrangedSubview(go)
        prompt.raise(over: view)
    }

    private func assembleStarter() -> String {
        let lines = rule.summaryLines().map { "\($0.0.caption) → \($0.1.caption)" }
        return ["Match the lit color to its required suit.",
                "",
                lines.joined(separator: "\n")].joined(separator: "\n")
    }

    override func lattice(_ board: LatticeBoard, didTap spot: LatticeSpot, chip: TileChip) {
        guard !paused, let bp = chip.blueprint else { return }
        let needed = rule.required(for: coordinator.currentHue)
        if bp.suit == needed {
            gainPoint(on: chip)
            board.reshuffleArtwork(animated: true)
        } else {
            bust(on: chip)
        }
    }
}
