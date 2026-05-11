//
//  RulebookStage.swift
//  Static rules / how-to-play page.
//

import UIKit

final class RulebookStage: CornerstoneStage {

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent()
    }

    private func layoutContent() {
        let backChip = GhostButton(caption: "BACK")
        backChip.addTarget(self, action: #selector(turnBack), for: .touchUpInside)
        backChip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backChip)

        let title = UILabel()
        title.text = "How to Play"
        title.font = GlyphScribe.heavy(CanvasMetric.scaled(28))
        title.textColor = HuePantry.chalk
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)

        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)

        let column = UIStackView()
        column.axis = .vertical
        column.spacing = CanvasMetric.scaled(14)
        column.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(column)

        let primer1 = primerCard(title: "Mode 1 · Red Yellow Green",
                                 lines: [
                                    "A 5×5 board of mahjong tiles.",
                                    "A lantern above the board cycles between Red, Yellow, and Green every 5–10 seconds.",
                                    "Each round assigns a suit to each color (e.g. Red → Character).",
                                    "Tap any tile of the required suit while the matching light is on.",
                                    "Each correct tap scores +10 and reshuffles the board."
                                 ])
        let primer2 = primerCard(title: "Mode 2 · Traffic Lights",
                                 lines: [
                                    "Tiles stay fixed but every tile has a Red, Yellow, or Green backing.",
                                    "Backings change color over time. The higher your score, the faster.",
                                    "Tap only tiles whose backing matches the current beacon color.",
                                    "Tap something else and the run ends."
                                 ])
        let primer3 = primerCard(title: "Mode 3 · Triple Streak",
                                 lines: [
                                    "Same colored backings as Traffic Lights.",
                                    "When the lantern lights, chain THREE taps on tiles whose backing matches its color.",
                                    "A timer bar drains under the lantern — empty it before completing the chain and the run ends.",
                                    "Each completed chain scores +30, the bar resets, and the board re-tints.",
                                    "Tap a wrong color and the run ends instantly."
                                 ])
        let primer4 = primerCard(title: "Mode 4 · Lantern Veil",
                                 lines: [
                                    "Same suit-rule mapping as Red Yellow Green.",
                                    "Before every color shift the lantern dims for ~1 second — a red 'DON'T TAP' badge warns you.",
                                    "Tap during the veil and the run ends, even if the suit is correct.",
                                    "Otherwise +10 per matching tap, board reshuffles after each correct one.",
                                    "Veils get longer as your score grows. Read the lantern carefully."
                                 ])
        let primer5 = primerCard(title: "General Tips",
                                 lines: [
                                    "Stay calm. Memorize the assignment first.",
                                    "Watch the lantern, not the tile, when the light shifts.",
                                    "Your best score per mode is saved on the leaderboard."
                                 ])
        column.addArrangedSubview(primer1)
        column.addArrangedSubview(primer2)
        column.addArrangedSubview(primer3)
        column.addArrangedSubview(primer4)
        column.addArrangedSubview(primer5)

        NSLayoutConstraint.activate([
            backChip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backChip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backChip.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(80)),
            backChip.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(40)),

            title.topAnchor.constraint(equalTo: backChip.bottomAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            scroll.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 18),
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            column.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 8),
            column.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -24),
            column.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 24),
            column.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -24),
            column.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -48)
        ])
    }

    private func primerCard(title: String, lines: [String]) -> UIView {
        let card = UIView()
        card.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        card.layer.cornerRadius = CanvasMetric.corner(20)
        card.layer.cornerCurve = .continuous
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.10).cgColor

        let head = UILabel()
        head.text = title
        head.font = GlyphScribe.heavy(CanvasMetric.scaled(17))
        head.textColor = HuePantry.chalk
        head.numberOfLines = 0

        let column = UIStackView(arrangedSubviews: [head] + lines.map { bulletLine($0) })
        column.axis = .vertical
        column.spacing = 10
        column.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(column)

        NSLayoutConstraint.activate([
            column.topAnchor.constraint(equalTo: card.topAnchor, constant: 18),
            column.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 18),
            column.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -18),
            column.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -18)
        ])
        return card
    }

    private func bulletLine(_ text: String) -> UIView {
        let dot = UIView()
        dot.backgroundColor = HuePantry.saffron
        dot.layer.cornerRadius = 3
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.widthAnchor.constraint(equalToConstant: 6).isActive = true
        dot.heightAnchor.constraint(equalToConstant: 6).isActive = true

        let label = UILabel()
        label.text = text
        label.font = GlyphScribe.regular(CanvasMetric.scaled(13))
        label.textColor = HuePantry.mute
        label.numberOfLines = 0

        let row = UIStackView(arrangedSubviews: [dot, label])
        row.axis = .horizontal
        row.alignment = .top
        row.spacing = 10
        let dotWrap = UIView()
        dotWrap.translatesAutoresizingMaskIntoConstraints = false
        dotWrap.addSubview(dot)
        NSLayoutConstraint.activate([
            dot.centerXAnchor.constraint(equalTo: dotWrap.centerXAnchor),
            dot.topAnchor.constraint(equalTo: dotWrap.topAnchor, constant: 7),
            dotWrap.widthAnchor.constraint(equalToConstant: 10),
            dotWrap.heightAnchor.constraint(greaterThanOrEqualToConstant: 14)
        ])
        let outer = UIStackView(arrangedSubviews: [dotWrap, label])
        outer.axis = .horizontal
        outer.alignment = .top
        outer.spacing = 10
        return outer
    }

    @objc private func turnBack() {
        PulseTactile.tap()
        dismiss(animated: true)
    }
}
