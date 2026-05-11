//
//  VaultStash.swift
//  Persistent storage for scores and preferences.
//

import Foundation

struct LedgerEntry: Codable, Equatable {
    let score: Int
    let mode: String
    let stampedAt: Date
}

enum VaultStash {

    private static let rosterKey = "ryg.ledger.roster"
    private static let quakeKey = "ryg.prefs.quake"
    private static let tuneKey = "ryg.prefs.tune"
    private static let primedKey = "ryg.prefs.primed"

    static func bootstrap() {
        let defs = UserDefaults.standard
        if defs.object(forKey: quakeKey) == nil { defs.set(true, forKey: quakeKey) }
        if defs.object(forKey: tuneKey) == nil { defs.set(true, forKey: tuneKey) }
    }

    static var hapticsOn: Bool {
        get { UserDefaults.standard.bool(forKey: quakeKey) }
        set { UserDefaults.standard.set(newValue, forKey: quakeKey) }
    }

    static var melodyOn: Bool {
        get { UserDefaults.standard.bool(forKey: tuneKey) }
        set { UserDefaults.standard.set(newValue, forKey: tuneKey) }
    }

    static var primerShown: Bool {
        get { UserDefaults.standard.bool(forKey: primedKey) }
        set { UserDefaults.standard.set(newValue, forKey: primedKey) }
    }

    static func archive(_ entry: LedgerEntry) {
        var current = roster()
        current.append(entry)
        current.sort { $0.score > $1.score }
        if current.count > 50 { current = Array(current.prefix(50)) }
        if let data = try? JSONEncoder().encode(current) {
            UserDefaults.standard.set(data, forKey: rosterKey)
        }
    }

    static func roster() -> [LedgerEntry] {
        guard let data = UserDefaults.standard.data(forKey: rosterKey),
              let list = try? JSONDecoder().decode([LedgerEntry].self, from: data) else {
            return []
        }
        return list
    }

    static func roster(for mode: String) -> [LedgerEntry] {
        roster().filter { $0.mode == mode }
    }

    static func topScore(for mode: String) -> Int {
        roster(for: mode).first?.score ?? 0
    }

    static func clearRoster() {
        UserDefaults.standard.removeObject(forKey: rosterKey)
    }
}
