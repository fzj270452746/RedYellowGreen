//
//  ModeRouletteStage.swift
//  Lets the player pick between the two play modes.
//

import UIKit

final class ModeRouletteStage: CornerstoneStage {

    private let subLine = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutHeader()
        layoutCards()
    }

    private func layoutHeader() {
        let backChip = GhostButton(caption: "BACK")
        backChip.addTarget(self, action: #selector(turnBack), for: .touchUpInside)
        backChip.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backChip)

        let title = UILabel()
        title.text = "Choose a Mode"
        title.font = GlyphScribe.heavy(CanvasMetric.scaled(28))
        title.textColor = HuePantry.chalk
        title.textAlignment = .left
        title.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(title)

        subLine.text = "Four ways to play. Same lights, different challenge."
        subLine.font = GlyphScribe.regular(CanvasMetric.scaled(13))
        subLine.textColor = HuePantry.mute
        subLine.numberOfLines = 0
        subLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subLine)

        NSLayoutConstraint.activate([
            backChip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backChip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backChip.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(80)),
            backChip.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(40)),

            title.topAnchor.constraint(equalTo: backChip.bottomAnchor, constant: 18),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            title.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            subLine.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 6),
            subLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            subLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }

    private func layoutCards() {
        let primer = ModeCard(title: "Red Yellow Green",
                              subtitle: "Memorize the lantern rule. Tap the matching suit when the light shines.",
                              palette: [HuePantry.cinnabarSoft, HuePantry.cinnabar],
                              tag: 1)
        primer.addTarget(self, action: #selector(launchMode(_:)), for: .touchUpInside)

        let secondary = ModeCard(title: "Traffic Lights",
                                 subtitle: "Tiles change color over time. Tap only those matching the current beacon.",
                                 palette: [HuePantry.verdantSoft, HuePantry.verdant],
                                 tag: 2)
        secondary.addTarget(self, action: #selector(launchMode(_:)), for: .touchUpInside)

        let triple = ModeCard(title: "Triple Streak",
                              subtitle: "Chain three matching backings before the bar empties. +30 per chain.",
                              palette: [HuePantry.lilacAccent, HuePantry.azureAccent],
                              tag: 3)
        triple.addTarget(self, action: #selector(launchMode(_:)), for: .touchUpInside)

        let veil = ModeCard(title: "Lantern Veil",
                            subtitle: "Same suit rule, but the lantern dims before each shift. Don't tap in the dark.",
                            palette: [HuePantry.coralAccent, HuePantry.cinnabar],
                            tag: 4)
        veil.addTarget(self, action: #selector(launchMode(_:)), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [primer, secondary, triple, veil])
        stack.axis = .vertical
        stack.spacing = CanvasMetric.scaled(14)
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scroll)
        scroll.addSubview(stack)

        let cardHeight = CanvasMetric.scaled(132)
        NSLayoutConstraint.activate([
            scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scroll.topAnchor.constraint(equalTo: subLine.bottomAnchor, constant: CanvasMetric.scaled(18)),
            scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            stack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 4),
            stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -8),
            stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -24),
            stack.widthAnchor.constraint(equalTo: scroll.widthAnchor, constant: -48),

            primer.heightAnchor.constraint(equalToConstant: cardHeight),
            secondary.heightAnchor.constraint(equalToConstant: cardHeight),
            triple.heightAnchor.constraint(equalToConstant: cardHeight),
            veil.heightAnchor.constraint(equalToConstant: cardHeight)
        ])
    }

    @objc private func launchMode(_ sender: ModeCard) {
        PulseTactile.tap()
        let runner: UIViewController
        switch sender.tag {
        case 1: runner = ScholarMatchStage()
        case 2: runner = SignalRushStage()
        case 3: runner = TripleStreakStage()
        case 4: runner = VeilHuntStage()
        default: runner = ScholarMatchStage()
        }
        runner.modalPresentationStyle = .fullScreen
        present(runner, animated: true)
    }

    @objc private func turnBack() {
        PulseTactile.tap()
        dismiss(animated: true)
    }
}

final class ModeCard: UIControl {

    private let backdrop = GradientPlate()
    private let titleLabel = UILabel()
    private let subLabel = UILabel()
    private let arrow = UILabel()

    init(title: String, subtitle: String, palette: [UIColor], tag: Int) {
        super.init(frame: .zero)
        self.tag = tag
        configure(palette: palette)
        titleLabel.text = title
        subLabel.text = subtitle
    }

    required init?(coder: NSCoder) { nil }

    private func configure(palette: [UIColor]) {
        layer.cornerRadius = CanvasMetric.corner(24)
        layer.cornerCurve = .continuous
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(width: 0, height: 8)

        backdrop.palette = palette
        backdrop.layer.cornerRadius = CanvasMetric.corner(24)
        backdrop.layer.cornerCurve = .continuous
        backdrop.clipsToBounds = true
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        backdrop.isUserInteractionEnabled = false
        addSubview(backdrop)

        titleLabel.font = GlyphScribe.heavy(CanvasMetric.scaled(22))
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0

        subLabel.font = GlyphScribe.regular(CanvasMetric.scaled(13))
        subLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        subLabel.numberOfLines = 0

        arrow.text = "→"
        arrow.font = GlyphScribe.heavy(CanvasMetric.scaled(28))
        arrow.textColor = .white

        let stack = UIStackView(arrangedSubviews: [titleLabel, subLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        arrow.translatesAutoresizingMaskIntoConstraints = false
        addSubview(arrow)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: bottomAnchor),
            backdrop.leadingAnchor.constraint(equalTo: leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: trailingAnchor),

            stack.topAnchor.constraint(equalTo: topAnchor, constant: 22),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 22),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -56),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -22),

            arrow.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
            arrow.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -22)
        ])

        addTarget(self, action: #selector(touchedDown), for: .touchDown)
        addTarget(self, action: #selector(touchedUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func touchedDown() {
        UIView.animate(withDuration: 0.12) { self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97) }
    }

    @objc private func touchedUp() {
        UIView.animate(withDuration: 0.18) { self.transform = .identity }
    }
}
