//
//  HuePantry.swift
//  Color tokens used across the app.
//

import UIKit

enum HuePantry {

    static let voidShade = UIColor(red: 0.05, green: 0.04, blue: 0.14, alpha: 1)
    static let abyssShade = UIColor(red: 0.10, green: 0.07, blue: 0.22, alpha: 1)
    static let twilightShade = UIColor(red: 0.16, green: 0.12, blue: 0.32, alpha: 1)
    static let mistShade = UIColor(red: 0.24, green: 0.20, blue: 0.42, alpha: 1)

    static let cinnabar = UIColor(red: 0.97, green: 0.27, blue: 0.34, alpha: 1)
    static let cinnabarSoft = UIColor(red: 1.00, green: 0.49, blue: 0.55, alpha: 1)
    static let saffron = UIColor(red: 1.00, green: 0.78, blue: 0.20, alpha: 1)
    static let saffronSoft = UIColor(red: 1.00, green: 0.86, blue: 0.42, alpha: 1)
    static let verdant = UIColor(red: 0.30, green: 0.84, blue: 0.50, alpha: 1)
    static let verdantSoft = UIColor(red: 0.55, green: 0.92, blue: 0.65, alpha: 1)

    static let chalk = UIColor.white
    static let mute = UIColor(white: 1, alpha: 0.62)
    static let glow = UIColor(white: 1, alpha: 0.18)
    static let stroke = UIColor(white: 1, alpha: 0.10)

    static let coralAccent = UIColor(red: 1.00, green: 0.45, blue: 0.55, alpha: 1)
    static let lilacAccent = UIColor(red: 0.65, green: 0.45, blue: 1.00, alpha: 1)
    static let azureAccent = UIColor(red: 0.32, green: 0.72, blue: 1.00, alpha: 1)

    static func gradient(for tint: TintFlavor) -> [UIColor] {
        switch tint {
        case .crimson: return [cinnabarSoft, cinnabar]
        case .amber: return [saffronSoft, saffron]
        case .jade: return [verdantSoft, verdant]
        case .royal: return [lilacAccent, azureAccent]
        case .ember: return [coralAccent, cinnabar]
        }
    }
}

enum TintFlavor {
    case crimson, amber, jade, royal, ember
}
