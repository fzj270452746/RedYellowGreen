//
//  ArenaStage.swift
//  Shared base for both play modes.
//

import UIKit

class ArenaStage: CornerstoneStage, CadenceObserver, LatticeBoardDelegate {

    let hud = HudPanel()
    let beacon = LanternBeacon()
    let board = LatticeBoard()
    let ruleStrip = RuleBoardlet()
    let backChip = GhostButton(caption: "QUIT")
    let pauseChip = GhostButton(caption: "PAUSE")

    let coordinator = CadenceCoordinator()
    var rule = RuleAlmanac.freshDeal()
    var score: Int = 0
    var paused: Bool = false

    var modeKey: String { "Generic" }
    var modeTitle: String { "Generic" }

    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator.observer = self
        board.delegate = self
        layoutShell()
        showStarter()
    }

    func layoutShell() {
        backChip.addTarget(self, action: #selector(askQuit), for: .touchUpInside)
        pauseChip.addTarget(self, action: #selector(togglePause), for: .touchUpInside)
        backChip.translatesAutoresizingMaskIntoConstraints = false
        pauseChip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backChip)
        view.addSubview(pauseChip)

        hud.translatesAutoresizingMaskIntoConstraints = false
        hud.best = VaultStash.topScore(for: modeKey)
        view.addSubview(hud)

        beacon.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(beacon)

        ruleStrip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ruleStrip)

        board.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(board)

        let boardSide: CGFloat = min(CanvasMetric.smallEdge - 32, 460)

        NSLayoutConstraint.activate([
            backChip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backChip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backChip.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(70)),
            backChip.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(36)),

            pauseChip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            pauseChip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            pauseChip.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(80)),
            pauseChip.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(36)),

            hud.topAnchor.constraint(equalTo: backChip.bottomAnchor, constant: 12),
            hud.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            hud.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            hud.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(70)),

            beacon.topAnchor.constraint(equalTo: hud.bottomAnchor, constant: 14),
            beacon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            beacon.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(74)),
            beacon.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(220)),

            ruleStrip.topAnchor.constraint(equalTo: beacon.bottomAnchor, constant: 14),
            ruleStrip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            ruleStrip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            ruleStrip.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(46)),

            board.topAnchor.constraint(equalTo: ruleStrip.bottomAnchor, constant: 18),
            board.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            board.widthAnchor.constraint(equalToConstant: boardSide),
            board.heightAnchor.constraint(equalToConstant: boardSide)
        ])
    }

    // Subclasses override
    func showStarter() { }
    func absorbRule() { ruleStrip.absorb(rule) }

    func ignite() {
        coordinator.ignite()
    }

    // MARK: - CadenceObserver
    func cadenceDidShift(to hue: BeaconHue, holdFor seconds: TimeInterval) {
        beacon.swing(to: hue)
    }

    // MARK: - LatticeBoardDelegate
    func lattice(_ board: LatticeBoard, didTap spot: LatticeSpot, chip: TileChip) { }

    // MARK: - Score helpers
    func gainPoint(on chip: TileChip) {
        score += 10
        hud.score = score
        chip.flashCorrect()
        if VaultStash.hapticsOn { PulseTactile.tap() }
        coordinator.tighten(by: score)
    }

    func bust(on chip: TileChip) {
        chip.flashWrong()
        if VaultStash.hapticsOn { PulseTactile.scold() }
        coordinator.extinguish()
        showFinish()
    }

    func showFinish() {
        let entry = LedgerEntry(score: score, mode: modeKey, stampedAt: Date())
        if score > 0 { VaultStash.archive(entry) }
        let best = VaultStash.topScore(for: modeKey)
        let prompt = PromptCurtain(title: "Game Over",
                                    body: "You scored \(score) points.\nBest: \(best) pts")

        let again = GlossButton(tint: .crimson)
        again.caption = "PLAY AGAIN"
        again.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(48)).isActive = true
        again.addAction(UIAction { [weak self, weak prompt] _ in
            prompt?.dismiss()
            self?.restart()
        }, for: .touchUpInside)

        let goHome = GhostButton(caption: "EXIT")
        goHome.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(46)).isActive = true
        goHome.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)

        prompt.actionStack.addArrangedSubview(again)
        prompt.actionStack.addArrangedSubview(goHome)
        prompt.raise(over: view)
    }

    func restart() {
        score = 0
        hud.score = 0
        rule = RuleAlmanac.freshDeal()
        absorbRule()
        board.wipeOverlays()
        showStarter()
    }

    @objc func togglePause() {
        if paused {
            paused = false
            pauseChip.caption = "PAUSE"
            coordinator.ignite()
        } else {
            paused = true
            pauseChip.caption = "RESUME"
            coordinator.extinguish()
            let prompt = PromptCurtain(title: "Paused", body: "Take a breath. Tap resume to continue.")
            let go = GlossButton(tint: .jade)
            go.caption = "RESUME"
            go.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(48)).isActive = true
            go.addAction(UIAction { [weak self, weak prompt] _ in
                prompt?.dismiss()
                self?.togglePause()
            }, for: .touchUpInside)
            let bail = GhostButton(caption: "EXIT")
            bail.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(46)).isActive = true
            bail.addAction(UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }, for: .touchUpInside)
            prompt.actionStack.addArrangedSubview(go)
            prompt.actionStack.addArrangedSubview(bail)
            prompt.raise(over: view)
        }
    }

    @objc func askQuit() {
        if score == 0 {
            dismiss(animated: true)
            return
        }
        coordinator.extinguish()
        let prompt = PromptCurtain(title: "Quit run?", body: "Your score will be saved.")
        let yes = GlossButton(tint: .ember)
        yes.caption = "QUIT"
        yes.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(48)).isActive = true
        yes.addAction(UIAction { [weak self, weak prompt] _ in
            prompt?.dismiss()
            self?.showFinish()
        }, for: .touchUpInside)
        let no = GhostButton(caption: "KEEP PLAYING")
        no.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(46)).isActive = true
        no.addAction(UIAction { [weak self, weak prompt] _ in
            prompt?.dismiss()
            self?.coordinator.ignite()
        }, for: .touchUpInside)
        prompt.actionStack.addArrangedSubview(yes)
        prompt.actionStack.addArrangedSubview(no)
        prompt.raise(over: view)
    }
}
