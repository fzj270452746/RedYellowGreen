//
//  GlyphScribe.swift
//  Typography helpers.
//

import UIKit

enum GlyphScribe {

    static func heavy(_ size: CGFloat) -> UIFont {
        UIFont(name: "AvenirNext-Heavy", size: size) ?? .systemFont(ofSize: size, weight: .heavy)
    }

    static func bold(_ size: CGFloat) -> UIFont {
        UIFont(name: "AvenirNext-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)
    }

    static func medium(_ size: CGFloat) -> UIFont {
        UIFont(name: "AvenirNext-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)
    }

    static func regular(_ size: CGFloat) -> UIFont {
        UIFont(name: "AvenirNext-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }

    static func mono(_ size: CGFloat) -> UIFont {
        UIFont(name: "Menlo-Bold", size: size) ?? .monospacedSystemFont(ofSize: size, weight: .bold)
    }
}
