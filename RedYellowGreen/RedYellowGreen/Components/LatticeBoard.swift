//
//  LatticeBoard.swift
//  5x5 grid of TileChip with delegate notifications.
//

import UIKit

protocol LatticeBoardDelegate: AnyObject {
    func lattice(_ board: LatticeBoard, didTap spot: LatticeSpot, chip: TileChip)
}

final class LatticeBoard: UIView {

    weak var delegate: LatticeBoardDelegate?

    let rows = 5
    let columns = 5
    private(set) var chips: [[TileChip]] = []

    init() {
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) { nil }

    private func configure() {
        backgroundColor = .clear
        var rowStacks: [UIStackView] = []
        chips.removeAll()
        for r in 0..<rows {
            var rowChips: [TileChip] = []
            for c in 0..<columns {
                let chip = TileChip()
                chip.tag = r * columns + c
                chip.addTarget(self, action: #selector(chipTouched(_:)), for: .touchUpInside)
                chip.translatesAutoresizingMaskIntoConstraints = false
                chip.widthAnchor.constraint(equalTo: chip.heightAnchor).isActive = true
                rowChips.append(chip)
                _ = c
            }
            chips.append(rowChips)
            let row = UIStackView(arrangedSubviews: rowChips)
            row.axis = .horizontal
            row.spacing = CanvasMetric.scaled(8)
            row.distribution = .fillEqually
            rowStacks.append(row)
        }
        let column = UIStackView(arrangedSubviews: rowStacks)
        column.axis = .vertical
        column.spacing = CanvasMetric.scaled(8)
        column.distribution = .fillEqually
        column.translatesAutoresizingMaskIntoConstraints = false
        addSubview(column)
        NSLayoutConstraint.activate([
            column.topAnchor.constraint(equalTo: topAnchor),
            column.leadingAnchor.constraint(equalTo: leadingAnchor),
            column.trailingAnchor.constraint(equalTo: trailingAnchor),
            column.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func chip(at spot: LatticeSpot) -> TileChip {
        chips[spot.row][spot.column]
    }

    func eachSpot(_ body: (LatticeSpot, TileChip) -> Void) {
        for r in 0..<rows {
            for c in 0..<columns {
                body(LatticeSpot(row: r, column: c), chips[r][c])
            }
        }
    }

    func reshuffleArtwork(animated: Bool) {
        eachSpot { _, chip in
            let bp = TileBlueprint.random()
            if animated {
                UIView.transition(with: chip,
                                  duration: 0.18,
                                  options: .transitionFlipFromRight,
                                  animations: {
                    chip.blueprint = bp
                }, completion: nil)
            } else {
                chip.blueprint = bp
            }
        }
    }

    func reshuffleTints(animated: Bool) {
        eachSpot { _, chip in
            let tone = BeaconHue.allCases.randomElement()
            if animated {
                UIView.transition(with: chip,
                                  duration: 0.22,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    chip.backingTint = tone
                }, completion: nil)
            } else {
                chip.backingTint = tone
            }
        }
    }

    func wipeOverlays() {
        eachSpot { _, chip in chip.wipeOverlays() }
    }

    @objc private func chipTouched(_ sender: TileChip) {
        let row = sender.tag / columns
        let col = sender.tag % columns
        delegate?.lattice(self, didTap: LatticeSpot(row: row, column: col), chip: sender)
    }
}
