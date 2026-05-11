//
//  LedgerWallStage.swift
//  Leaderboard with two segmented modes.
//

import UIKit

final class LedgerWallStage: CornerstoneStage {

    private let modePicker = ModeStrip()
    private let table = UITableView(frame: .zero, style: .plain)
    private let emptyChip = UILabel()
    private let modeKeys = ["RYG", "Traffic", "Streak", "Veil"]
    private let modeNames = ["Red Yellow Green", "Traffic Lights", "Triple Streak", "Lantern Veil"]
    private var rows: [LedgerEntry] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutContent()
        reloadRows()
    }

    private func layoutContent() {
        let backChip = GhostButton(caption: "BACK")
        backChip.addTarget(self, action: #selector(turnBack), for: .touchUpInside)
        backChip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backChip)

        let title = UILabel()
        title.text = "Leaderboard"
        title.font = GlyphScribe.heavy(CanvasMetric.scaled(28))
        title.textColor = HuePantry.chalk
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)

        modePicker.captions = modeNames
        modePicker.selectedIndex = 0
        modePicker.onPick = { [weak self] _ in
            PulseTactile.tap()
            self?.reloadRows()
        }
        modePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(modePicker)

        table.backgroundColor = .clear
        table.separatorStyle = .none
        table.dataSource = self
        table.delegate = self
        table.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 24, right: 0)
        table.register(LedgerCell.self, forCellReuseIdentifier: "row")
        table.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(table)

        emptyChip.text = "No scores yet.\nGo set the first record!"
        emptyChip.numberOfLines = 0
        emptyChip.font = GlyphScribe.medium(CanvasMetric.scaled(14))
        emptyChip.textColor = HuePantry.mute
        emptyChip.textAlignment = .center
        emptyChip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyChip)

        NSLayoutConstraint.activate([
            backChip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backChip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backChip.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(80)),
            backChip.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(40)),

            title.topAnchor.constraint(equalTo: backChip.bottomAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),

            modePicker.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 18),
            modePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            modePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            modePicker.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(40)),

            table.topAnchor.constraint(equalTo: modePicker.bottomAnchor, constant: 14),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            emptyChip.centerXAnchor.constraint(equalTo: table.centerXAnchor),
            emptyChip.centerYAnchor.constraint(equalTo: table.centerYAnchor)
        ])
    }

    private func reloadRows() {
        let key = modeKeys[modePicker.selectedIndex]
        rows = VaultStash.roster(for: key)
        emptyChip.isHidden = !rows.isEmpty
        table.reloadData()
    }

    @objc private func turnBack() {
        PulseTactile.tap()
        dismiss(animated: true)
    }
}

extension LedgerWallStage: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "row", for: indexPath) as! LedgerCell
        let entry = rows[indexPath.row]
        cell.absorb(rank: indexPath.row + 1, entry: entry)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CanvasMetric.scaled(64)
    }
}

final class LedgerCell: UITableViewCell {

    private let card = UIView()
    private let rankLabel = UILabel()
    private let scoreLabel = UILabel()
    private let dateLabel = UILabel()
    private let trophy = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        configure()
    }

    required init?(coder: NSCoder) { nil }

    private func configure() {
        card.backgroundColor = UIColor.black.withAlphaComponent(0.30)
        card.layer.cornerRadius = CanvasMetric.corner(16)
        card.layer.cornerCurve = .continuous
        card.layer.borderWidth = 1
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.08).cgColor
        card.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(card)

        trophy.layer.cornerRadius = CanvasMetric.scaled(18)
        trophy.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(trophy)

        rankLabel.font = GlyphScribe.heavy(CanvasMetric.scaled(15))
        rankLabel.textColor = .white
        rankLabel.textAlignment = .center
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        trophy.addSubview(rankLabel)

        scoreLabel.font = GlyphScribe.heavy(CanvasMetric.scaled(20))
        scoreLabel.textColor = HuePantry.chalk
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(scoreLabel)

        dateLabel.font = GlyphScribe.regular(CanvasMetric.scaled(11))
        dateLabel.textColor = HuePantry.mute
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            card.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            card.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            card.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            trophy.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            trophy.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            trophy.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(36)),
            trophy.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(36)),

            rankLabel.centerXAnchor.constraint(equalTo: trophy.centerXAnchor),
            rankLabel.centerYAnchor.constraint(equalTo: trophy.centerYAnchor),

            scoreLabel.leadingAnchor.constraint(equalTo: trophy.trailingAnchor, constant: 14),
            scoreLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),

            dateLabel.leadingAnchor.constraint(equalTo: scoreLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 2),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: card.trailingAnchor, constant: -16)
        ])
    }

    func absorb(rank: Int, entry: LedgerEntry) {
        rankLabel.text = "\(rank)"
        scoreLabel.text = "\(entry.score) pts"
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        dateLabel.text = f.string(from: entry.stampedAt)

        switch rank {
        case 1: trophy.backgroundColor = HuePantry.saffron
        case 2: trophy.backgroundColor = HuePantry.lilacAccent
        case 3: trophy.backgroundColor = HuePantry.verdant
        default: trophy.backgroundColor = HuePantry.mistShade
        }
    }
}

final class ModeStrip: UIView {

    var captions: [String] = [] { didSet { rebuild() } }
    var selectedIndex: Int = 0 { didSet { repaint() } }
    var onPick: ((Int) -> Void)?

    private let scroll = UIScrollView()
    private let row = UIStackView()
    private var pills: [UIControl] = []

    init() {
        super.init(frame: .zero)
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroll)
        row.axis = .horizontal
        row.spacing = 8
        row.translatesAutoresizingMaskIntoConstraints = false
        scroll.addSubview(row)
        NSLayoutConstraint.activate([
            scroll.topAnchor.constraint(equalTo: topAnchor),
            scroll.leadingAnchor.constraint(equalTo: leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: trailingAnchor),
            scroll.bottomAnchor.constraint(equalTo: bottomAnchor),

            row.topAnchor.constraint(equalTo: scroll.topAnchor),
            row.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            row.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 24),
            row.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -24),
            row.heightAnchor.constraint(equalTo: scroll.heightAnchor)
        ])
    }

    required init?(coder: NSCoder) { nil }

    private func rebuild() {
        for pill in pills { row.removeArrangedSubview(pill); pill.removeFromSuperview() }
        pills.removeAll()
        for (idx, text) in captions.enumerated() {
            let pill = pillButton(text: text, idx: idx)
            row.addArrangedSubview(pill)
            pills.append(pill)
        }
        repaint()
    }

    private func pillButton(text: String, idx: Int) -> UIControl {
        let btn = PillChip()
        btn.caption = text
        btn.tag = idx
        btn.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        return btn
    }

    @objc private func tapped(_ sender: PillChip) {
        selectedIndex = sender.tag
        onPick?(selectedIndex)
    }

    private func repaint() {
        for (idx, pill) in pills.enumerated() {
            (pill as? PillChip)?.active = (idx == selectedIndex)
        }
    }
}

final class PillChip: UIControl {

    private let label = UILabel()

    var caption: String = "" { didSet { label.text = caption } }
    var active: Bool = false { didSet { restyle() } }

    init() {
        super.init(frame: .zero)
        label.font = GlyphScribe.bold(CanvasMetric.scaled(13))
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -6),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18)
        ])
        layer.cornerRadius = CanvasMetric.corner(16)
        layer.cornerCurve = .continuous
        layer.borderWidth = 1
        restyle()
    }

    required init?(coder: NSCoder) { nil }

    private func restyle() {
        if active {
            backgroundColor = HuePantry.cinnabar
            layer.borderColor = HuePantry.cinnabar.cgColor
            label.textColor = .white
        } else {
            backgroundColor = UIColor.white.withAlphaComponent(0.08)
            layer.borderColor = UIColor.white.withAlphaComponent(0.12).cgColor
            label.textColor = HuePantry.mute
        }
    }
}
