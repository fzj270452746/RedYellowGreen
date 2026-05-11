//
//  TileBlueprint.swift
//  Domain model for a single mahjong piece and its kind.
//

import UIKit

enum SuitKind: Int, CaseIterable, Codable {
    case word
    case bird
    case circle

    var caption: String {
        switch self {
        case .word: return "Character"
        case .bird: return "Bamboo"
        case .circle: return "Dot"
        }
    }

    var assetPrefix: String {
        switch self {
        case .word: return "RYG-Word-"
        case .bird: return "RYG-Bird-"
        case .circle: return "RYG-Circle-"
        }
    }
}

enum BeaconHue: Int, CaseIterable, Codable {
    case crimson
    case amber
    case jade

    var caption: String {
        switch self {
        case .crimson: return "Red"
        case .amber: return "Yellow"
        case .jade: return "Green"
        }
    }

    var bulb: UIColor {
        switch self {
        case .crimson: return HuePantry.cinnabar
        case .amber: return HuePantry.saffron
        case .jade: return HuePantry.verdant
        }
    }

    var bulbSoft: UIColor {
        switch self {
        case .crimson: return HuePantry.cinnabarSoft
        case .amber: return HuePantry.saffronSoft
        case .jade: return HuePantry.verdantSoft
        }
    }
}

struct TileBlueprint: Equatable {
    let suit: SuitKind
    let pip: Int

    var artworkName: String { "\(suit.assetPrefix)\(pip)" }

    static func random() -> TileBlueprint {
        TileBlueprint(suit: SuitKind.allCases.randomElement()!, pip: Int.random(in: 1...9))
    }
}

struct LatticeSpot: Equatable {
    let row: Int
    let column: Int
}
