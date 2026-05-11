//
//  CadenceCoordinator.swift
//  Drives lantern hue rotations with random durations.
//

import Foundation

protocol CadenceObserver: AnyObject {
    func cadenceDidShift(to hue: BeaconHue, holdFor seconds: TimeInterval)
}

final class CadenceCoordinator {

    weak var observer: CadenceObserver?
    private var ticker: Timer?
    private(set) var currentHue: BeaconHue = .crimson
    private var paceFloor: TimeInterval = 5
    private var paceCeiling: TimeInterval = 10

    func tighten(by points: Int) {
        let drift = min(Double(points) / 200.0, 2.5)
        paceFloor = max(2.5, 5 - drift)
        paceCeiling = max(paceFloor + 1.5, 10 - drift * 1.5)
    }

    func ignite() {
        currentHue = BeaconHue.allCases.randomElement() ?? .crimson
        scheduleNext(initial: true)
    }

    func extinguish() {
        ticker?.invalidate()
        ticker = nil
    }

    private func scheduleNext(initial: Bool) {
        let hold = TimeInterval.random(in: paceFloor...paceCeiling)
        observer?.cadenceDidShift(to: currentHue, holdFor: hold)
        ticker?.invalidate()
        ticker = Timer.scheduledTimer(withTimeInterval: hold, repeats: false) { [weak self] _ in
            self?.flipHue()
        }
        _ = initial
    }

    private func flipHue() {
        var pool = BeaconHue.allCases
        pool.removeAll { $0 == currentHue }
        currentHue = pool.randomElement() ?? .amber
        scheduleNext(initial: false)
    }
}
