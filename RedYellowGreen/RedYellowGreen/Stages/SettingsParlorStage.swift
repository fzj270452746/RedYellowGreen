//
//  SettingsParlorStage.swift
//  Settings: haptics, sounds, clear leaderboard, about.
//

import UIKit

final class SettingsParlorStage: CornerstoneStage {

    private let quakeSwitch = UISwitch()
    private let tuneSwitch = UISwitch()

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
        title.text = "Settings"
        title.font = GlyphScribe.heavy(CanvasMetric.scaled(28))
        title.textColor = HuePantry.chalk
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)

        let card = makeCard()
        card.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(card)

        let aboutCard = makeAboutCard()
        aboutCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(aboutCard)

        NSLayoutConstraint.activate([
            backChip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backChip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backChip.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(80)),
            backChip.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(40)),

            title.topAnchor.constraint(equalTo: backChip.bottomAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            card.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 18),
            card.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            card.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            aboutCard.topAnchor.constraint(equalTo: card.bottomAnchor, constant: 16),
            aboutCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            aboutCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func makeCard() -> UIView {
        let host = panelView()

        let quakeRow = makeRow(label: "Haptics", control: quakeSwitch)
        quakeSwitch.isOn = VaultStash.hapticsOn
        quakeSwitch.onTintColor = HuePantry.verdant
        quakeSwitch.addTarget(self, action: #selector(quakeFlipped), for: .valueChanged)

        let tuneRow = makeRow(label: "Sound Effects", control: tuneSwitch)
        tuneSwitch.isOn = VaultStash.melodyOn
        tuneSwitch.onTintColor = HuePantry.verdant
        tuneSwitch.addTarget(self, action: #selector(tuneFlipped), for: .valueChanged)

        let clearBtn = GhostButton(caption: "CLEAR LEADERBOARD")
        clearBtn.addTarget(self, action: #selector(askClear), for: .touchUpInside)
        clearBtn.translatesAutoresizingMaskIntoConstraints = false
        clearBtn.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(46)).isActive = true

        let column = UIStackView(arrangedSubviews: [quakeRow, separator(), tuneRow, separator(), clearBtn])
        column.axis = .vertical
        column.spacing = 14
        column.translatesAutoresizingMaskIntoConstraints = false
        host.addSubview(column)

        NSLayoutConstraint.activate([
            column.topAnchor.constraint(equalTo: host.topAnchor, constant: 20),
            column.bottomAnchor.constraint(equalTo: host.bottomAnchor, constant: -20),
            column.leadingAnchor.constraint(equalTo: host.leadingAnchor, constant: 20),
            column.trailingAnchor.constraint(equalTo: host.trailingAnchor, constant: -20)
        ])
        return host
    }

    private func makeAboutCard() -> UIView {
        let host = panelView()
        let head = UILabel()
        head.text = "About"
        head.font = GlyphScribe.heavy(CanvasMetric.scaled(15))
        head.textColor = HuePantry.chalk

        let body = UILabel()
        body.text = "Mahjong RYG is a casual color-matching game inspired by traffic lights and the rhythm of mahjong tiles. No personal data is collected. Single-player only."
        body.font = GlyphScribe.regular(CanvasMetric.scaled(12))
        body.textColor = HuePantry.mute
        body.numberOfLines = 0

        let column = UIStackView(arrangedSubviews: [head, body])
        column.axis = .vertical
        column.spacing = 10
        column.translatesAutoresizingMaskIntoConstraints = false
        host.addSubview(column)
        NSLayoutConstraint.activate([
            column.topAnchor.constraint(equalTo: host.topAnchor, constant: 18),
            column.bottomAnchor.constraint(equalTo: host.bottomAnchor, constant: -18),
            column.leadingAnchor.constraint(equalTo: host.leadingAnchor, constant: 18),
            column.trailingAnchor.constraint(equalTo: host.trailingAnchor, constant: -18)
        ])
        return host
    }

    private func panelView() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.32)
        v.layer.cornerRadius = CanvasMetric.corner(20)
        v.layer.cornerCurve = .continuous
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.white.withAlphaComponent(0.10).cgColor
        return v
    }

    private func makeRow(label text: String, control: UIView) -> UIView {
        let row = UIView()
        let lbl = UILabel()
        lbl.text = text
        lbl.font = GlyphScribe.bold(CanvasMetric.scaled(15))
        lbl.textColor = HuePantry.chalk
        lbl.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(lbl)
        control.translatesAutoresizingMaskIntoConstraints = false
        row.addSubview(control)
        NSLayoutConstraint.activate([
            lbl.leadingAnchor.constraint(equalTo: row.leadingAnchor),
            lbl.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            control.trailingAnchor.constraint(equalTo: row.trailingAnchor),
            control.centerYAnchor.constraint(equalTo: row.centerYAnchor),
            row.heightAnchor.constraint(greaterThanOrEqualToConstant: CanvasMetric.scaled(38))
        ])
        return row
    }

    private func separator() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.white.withAlphaComponent(0.06)
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }

    @objc private func quakeFlipped() {
        VaultStash.hapticsOn = quakeSwitch.isOn
        if VaultStash.hapticsOn { PulseTactile.tap() }
    }

    @objc private func tuneFlipped() {
        VaultStash.melodyOn = tuneSwitch.isOn
        if VaultStash.hapticsOn { PulseTactile.tap() }
    }

    @objc private func askClear() {
        let prompt = PromptCurtain(title: "Clear Leaderboard?",
                                    body: "All saved scores will be removed.\nThis cannot be undone.")
        let yes = GlossButton(tint: .ember)
        yes.caption = "CONFIRM"
        yes.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(48)).isActive = true
        yes.addAction(UIAction { [weak self, weak prompt] _ in
            VaultStash.clearRoster()
            PulseTactile.bump()
            prompt?.dismiss()
            if let host = self?.view {
                ToastFlare.waft("Leaderboard cleared", on: host)
            }
        }, for: .touchUpInside)

        let no = GhostButton(caption: "CANCEL")
        no.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(46)).isActive = true
        no.addAction(UIAction { [weak prompt] _ in
            prompt?.dismiss()
        }, for: .touchUpInside)

        prompt.actionStack.addArrangedSubview(yes)
        prompt.actionStack.addArrangedSubview(no)
        prompt.raise(over: view)
    }

    @objc private func turnBack() {
        PulseTactile.tap()
        dismiss(animated: true)
    }
}
