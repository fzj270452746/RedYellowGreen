//
//  GradientPlate.swift
//  Reusable gradient backdrop view.
//

import UIKit

final class GradientPlate: UIView {

    override class var layerClass: AnyClass { CAGradientLayer.self }

    var palette: [UIColor] = [HuePantry.voidShade, HuePantry.abyssShade] {
        didSet { applyPalette() }
    }

    var slope: (CGPoint, CGPoint) = (CGPoint(x: 0.5, y: 0), CGPoint(x: 0.5, y: 1)) {
        didSet {
            (layer as? CAGradientLayer)?.startPoint = slope.0
            (layer as? CAGradientLayer)?.endPoint = slope.1
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyPalette()
        (layer as? CAGradientLayer)?.startPoint = slope.0
        (layer as? CAGradientLayer)?.endPoint = slope.1
    }

    required init?(coder: NSCoder) { nil }

    private func applyPalette() {
        (layer as? CAGradientLayer)?.colors = palette.map { $0.cgColor }
    }
}
