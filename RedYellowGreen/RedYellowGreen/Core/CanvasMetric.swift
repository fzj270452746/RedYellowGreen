//
//  CanvasMetric.swift
//  Layout helpers that adapt iPhone & iPad screens.
//

import UIKit

enum CanvasMetric {

    static var screenWidth: CGFloat { UIScreen.main.bounds.width }
    static var screenHeight: CGFloat { UIScreen.main.bounds.height }
    static var smallEdge: CGFloat { min(screenWidth, screenHeight) }

    static var isCompactDevice: Bool { smallEdge < 380 }
    static var isRoomyDevice: Bool { smallEdge >= 600 }

    static func scaled(_ value: CGFloat) -> CGFloat {
        let base: CGFloat = 375
        let ratio = min(max(smallEdge / base, 0.85), 1.45)
        return value * ratio
    }

    static func mat(_ value: CGFloat) -> CGFloat {
        scaled(value)
    }

    static func corner(_ value: CGFloat) -> CGFloat {
        scaled(value)
    }
}
