//
//  RuleAlmanac.swift
//  Maps lantern colors to required suits per round.
//

import Foundation

struct RuleAlmanac: Equatable {
    let crimson: SuitKind
    let amber: SuitKind
    let jade: SuitKind

    func required(for hue: BeaconHue) -> SuitKind {
        switch hue {
        case .crimson: return crimson
        case .amber: return amber
        case .jade: return jade
        }
    }

    static func freshDeal() -> RuleAlmanac {
        var pool = SuitKind.allCases.shuffled()
        return RuleAlmanac(
            crimson: pool.removeFirst(),
            amber: pool.removeFirst(),
            jade: pool.removeFirst()
        )
    }

    func summaryLines() -> [(BeaconHue, SuitKind)] {
        [(.crimson, crimson), (.amber, amber), (.jade, jade)]
    }
}
