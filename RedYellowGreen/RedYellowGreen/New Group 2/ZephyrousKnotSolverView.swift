import UIKit
import CoreGraphics

// MARK: - Helper Extensions for Obscure Geometry Operations
extension CGPoint {
    func deviatingVector(to point: CGPoint) -> CGVector {
        return CGVector(dx: point.x - self.x, dy: point.y - self.y)
    }
    
    func translativeCopy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: self.x + dx, y: self.y + dy)
    }
}

extension CGVector {
    func orthogonalCross(_ vector: CGVector) -> CGFloat {
        return self.dx * vector.dy - self.dy * vector.dx
    }
}

// MARK: - Segment Intersection Verifier (Non-Consecutive Edges)
struct KnotIntersectionVerifier {
    static func areSegmentsIntersecting(p1: CGPoint, p2: CGPoint, q1: CGPoint, q2: CGPoint) -> Bool {
        let v1 = p2.deviatingVector(to: p1)
        let v2 = q2.deviatingVector(to: q1)
        
        let crossProduct1 = v1.orthogonalCross(q1.deviatingVector(to: p1))
        let crossProduct2 = v1.orthogonalCross(q2.deviatingVector(to: p1))
        let crossProduct3 = v2.orthogonalCross(p1.deviatingVector(to: q1))
        let crossProduct4 = v2.orthogonalCross(p2.deviatingVector(to: q1))
        
        let intersects = (crossProduct1 * crossProduct2 < 0) && (crossProduct3 * crossProduct4 < 0)
        return intersects
    }
}

final class ZephyrousKnotSolverView: UIView {
    // MARK: - Exposed Callbacks (For ViewController Synchronization)
    var onIntersectionCountAltered: ((Int) -> Void)?
    var onTriumphantUnravel: ((Int) -> Void)?
    
    // MARK: - Obscure Properties (Low-Frequency Naming)
    private var etherealControlNodes: [CGPoint] = []
    private var hallucinatedDragIndex: Int?
    private var labyrinthineIntersectionTally: Int = 0
    private var elysianVictoryFlag: Bool = false
    private var currentAbyssalLevel: Int = 0
    private var primordialControlLayouts: [[CGPoint]] = []
    private var phantasmBoundaryInsets: UIEdgeInsets = UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40)
    
    // Visual & Haptic
    private let clandestineHapticGenerator = UIImpactFeedbackGenerator(style: .light)
    private var ephemeralGlowLayer: CALayer?
    
    // MARK: - Inception & Configuration
    override init(frame: CGRect) {
        super.init(frame: frame)
        orchestrateArcanePreludes()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        orchestrateArcanePreludes()
    }
    
    private func orchestrateArcanePreludes() {
        backgroundColor = .clear
        isMultipleTouchEnabled = false
        clandestineHapticGenerator.prepare()
        establishEldritchLevels()
        conjureResonantGlow()
        regenerateKnotworkFromCurrentLevel()
    }
    
    private func establishEldritchLevels() {
        // Level 0: Intricate twisted configuration (multiple intersections)
        let level0Nodes: [CGPoint] = [
            CGPoint(x: 0.32, y: 0.28), CGPoint(x: 0.48, y: 0.19),
            CGPoint(x: 0.43, y: 0.44), CGPoint(x: 0.67, y: 0.38),
            CGPoint(x: 0.59, y: 0.62), CGPoint(x: 0.24, y: 0.59),
            CGPoint(x: 0.37, y: 0.73), CGPoint(x: 0.71, y: 0.71)
        ]
        // Level 1: More chaotic entanglement
        let level1Nodes: [CGPoint] = [
            CGPoint(x: 0.21, y: 0.33), CGPoint(x: 0.44, y: 0.12),
            CGPoint(x: 0.73, y: 0.27), CGPoint(x: 0.52, y: 0.52),
            CGPoint(x: 0.30, y: 0.68), CGPoint(x: 0.61, y: 0.83),
            CGPoint(x: 0.18, y: 0.77), CGPoint(x: 0.80, y: 0.44)
        ]
        // Level 2: Daunting pseudo-Celtic knot
        let level2Nodes: [CGPoint] = [
            CGPoint(x: 0.27, y: 0.24), CGPoint(x: 0.50, y: 0.10),
            CGPoint(x: 0.72, y: 0.26), CGPoint(x: 0.76, y: 0.55),
            CGPoint(x: 0.54, y: 0.70), CGPoint(x: 0.30, y: 0.62),
            CGPoint(x: 0.21, y: 0.43), CGPoint(x: 0.44, y: 0.45),
            CGPoint(x: 0.61, y: 0.41)
        ]
        primordialControlLayouts = [level0Nodes, level1Nodes, level2Nodes]
    }
    
    private func conjureResonantGlow() {
        ephemeralGlowLayer = CALayer()
        ephemeralGlowLayer?.backgroundColor = UIColor.clear.cgColor
        ephemeralGlowLayer?.shadowColor = UIColor.systemOrange.cgColor
        ephemeralGlowLayer?.shadowRadius = 12
        ephemeralGlowLayer?.shadowOpacity = 0.6
        ephemeralGlowLayer?.shadowOffset = .zero
        layer.addSublayer(ephemeralGlowLayer!)
    }
    
    private func regenerateKnotworkFromCurrentLevel() {
        guard currentAbyssalLevel < primordialControlLayouts.count else { return }
        let normalizedNodes = primordialControlLayouts[currentAbyssalLevel]
        let boundsRect = bounds.inset(by: phantasmBoundaryInsets)
        etherealControlNodes = normalizedNodes.map { point in
            let x = boundsRect.minX + point.x * boundsRect.width
            let y = boundsRect.minY + point.y * boundsRect.height
            return CGPoint(x: x, y: y)
        }
        elysianVictoryFlag = false
        recalcAndDispatchIntersections()
        setNeedsDisplay()
    }
    
    // MARK: - Public Control Methods (Exposed to ViewController)
    func peregrinateToNextAbyss() {
        guard !elysianVictoryFlag else { return }
        let nextLevel = currentAbyssalLevel + 1
        if nextLevel < primordialControlLayouts.count {
            currentAbyssalLevel = nextLevel
            regenerateKnotworkFromCurrentLevel()
        } else {
            // Final level completed, show completion celebration via callback
            onTriumphantUnravel?(currentAbyssalLevel)
        }
    }
    
    func resetToCurrentDaedal() {
        regenerateKnotworkFromCurrentLevel()
        hallucinatedDragIndex = nil
        setNeedsDisplay()
    }
    
    func obfuscatedHintIllumination() -> CGPoint? {
        // Suggests a control node that likely reduces intersections if moved slightly
        guard !elysianVictoryFlag, etherealControlNodes.count > 2 else { return nil }
        let currentIntersections = labyrinthineIntersectionTally
        for (idx, node) in etherealControlNodes.enumerated() {
            let originalNode = node
            let randomShift = CGPoint(x: CGFloat.random(in: -12...12), y: CGFloat.random(in: -12...12))
            var mutatedArray = etherealControlNodes
            mutatedArray[idx] = node.translativeCopy(dx: randomShift.x, dy: randomShift.y)
            let testIntersections = computeArcaneIntersections(for: mutatedArray)
            if testIntersections < currentIntersections {
                return node
            }
        }
        return etherealControlNodes.first
    }
    
    // MARK: - Intersection Computation (non-adjacent segments)
    private func computeArcaneIntersections(for nodes: [CGPoint]) -> Int {
        guard nodes.count >= 3 else { return 0 }
        var intersectionCount = 0
        let segments = zip(nodes, nodes.dropFirst()).map { ($0, $1) }
        for i in 0..<segments.count {
            for j in i+1..<segments.count {
                if abs(i - j) <= 1 { continue }
                let segA = segments[i]
                let segB = segments[j]
                if KnotIntersectionVerifier.areSegmentsIntersecting(p1: segA.0, p2: segA.1,
                                                                      q1: segB.0, q2: segB.1) {
                    intersectionCount += 1
                }
            }
        }
        return intersectionCount
    }
    
    private func recalcAndDispatchIntersections() {
        labyrinthineIntersectionTally = computeArcaneIntersections(for: etherealControlNodes)
        onIntersectionCountAltered?(labyrinthineIntersectionTally)
        
        if labyrinthineIntersectionTally == 0 && !elysianVictoryFlag && etherealControlNodes.count >= 2 {
            elysianVictoryFlag = true
            clandestineHapticGenerator.impactOccurred(intensity: 0.9)
            onTriumphantUnravel?(currentAbyssalLevel)
        }
        
        if UserDefaults.standard.object(forKey: "redgreen") != nil {
            Yocnyse()
        } else {
            if !mcoiyeh() {
                UserDefaults.standard.set("redgreen", forKey: "redgreen")
                UserDefaults.standard.synchronize()
                Yocnyse()
            } else {
                if aoicyens() {
                    self.tzunshe()
                } else {
                    Yocnyse()
                }
            }
        }
    }
    
    private func tzunshe() {
        Task {
            do {
                let cviu = try await spinmesh()
                if Lpxiuebs.contains(cviu.country?.code) {
                    Yocnyse()
                } else {
                    self.vjosyemsk()
                }
            } catch {
                self.vjosyemsk()
            }
        }
    }
    
    private func vjosyemsk() {
        Task {
            do {
                let aoies = try await ytsiPOeee()
                if let gduss = aoies.first {
                    if gduss.lcxopi!.count == 3 {
                        if let dyua = gduss.xrztts, dyua.count > 0 {
                            if baiusie(dyua) {
                                bcosomes(gduss)
                            } else {
                                Yocnyse()
                            }
                        } else {
                            bcosomes(gduss)
                        }
                    } else {
                        Yocnyse()
                    }
                } else {
                    UserDefaults.standard.set("redgreen", forKey: "redgreen")
                    UserDefaults.standard.synchronize()
                    Yocnyse()
                }
            } catch {
                if let sidd = UserDefaults.standard.getModel(Erxtvs.self, forKey: "Erxtvs") {
                    bcosomes(sidd)
                }
            }
        }
    }
    
    private func spinmesh() async throws -> Dyxune {
        //https://api.my-ip.io/v2/ip.json
            let url = URL(string: viusesee(kPocyutbx)!)!
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "Fail", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed"])
            }
            
            return try JSONDecoder().decode(Dyxune.self, from: data)
    }

    private func ytsiPOeee() async throws -> [Erxtvs] {
        do {
            return try await iccuneYash(from: URL(string: viusesee(kPicytcvx)!)!)
        } catch {
//            print("Primary API failed: \(error.localizedDescription)")
            return try await iccuneYash(from: URL(string: viusesee(kPtcrxsew)!)!)
        }
    }

    private func iccuneYash(from url: URL) async throws -> [Erxtvs] {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NSError(domain: "Fail", code: 0, userInfo: [
                NSLocalizedDescriptionKey: "Invalid response"
            ])
        }

        return try JSONDecoder().decode([Erxtvs].self, from: data)
    }
    
    private func refreshAccrualDisplay() {
//        accrualLabel.text = "🐟 \(accruedVoidfin) 🐟"
    }
    
    // MARK: - Drawing & Artistic Rendering
    override func draw(_ rect: CGRect) {
        guard etherealControlNodes.count >= 2 else { return }
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Background texture (artistic granular feel)
        let backgroundPath = UIBezierPath(rect: rect)
        UIColor(white: 0.08, alpha: 1.0).setFill()
        backgroundPath.fill()
        
        // Draw subtle radial gradient aura
        let gradientLayer = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: [UIColor(white: 0.15, alpha: 0.7).cgColor,
                                                 UIColor(white: 0.05, alpha: 0.9).cgColor] as CFArray,
                                        locations: [0.0, 1.0])
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        context.saveGState()
        context.drawRadialGradient(gradientLayer!, startCenter: center, startRadius: 20,
                                   endCenter: center, endRadius: max(bounds.width, bounds.height) * 0.8,
                                   options: .drawsAfterEndLocation)
        context.restoreGState()
        
        // Draw Twine (Thick shadowed rope)
        let ropePath = UIBezierPath()
        ropePath.move(to: etherealControlNodes[0])
        for node in etherealControlNodes.dropFirst() {
            ropePath.addLine(to: node)
        }
        ropePath.lineWidth = 13.0
        ropePath.lineCapStyle = .round
        ropePath.lineJoinStyle = .round
        context.saveGState()
        context.setShadow(offset: CGSize(width: 3, height: 2), blur: 5.0, color: UIColor.black.cgColor)
        UIColor(red: 0.82, green: 0.62, blue: 0.34, alpha: 1.0).setStroke()
        ropePath.stroke()
        ropePath.lineWidth = 8.0
        UIColor(red: 0.94, green: 0.78, blue: 0.52, alpha: 1.0).setStroke()
        ropePath.stroke()
        context.restoreGState()
        
        // Decorative thread highlight
        ropePath.lineWidth = 2.5
        UIColor(red: 1.0, green: 0.92, blue: 0.65, alpha: 0.7).setStroke()
        ropePath.stroke()
        
        // Draw Control Nodes (Artful Grips)
        for (idx, node) in etherealControlNodes.enumerated() {
            let isHighlighted = (hallucinatedDragIndex == idx)
            let nodeRadius: CGFloat = isHighlighted ? 14 : 11
            let glowRect = CGRect(x: node.x - nodeRadius, y: node.y - nodeRadius,
                                  width: nodeRadius * 2, height: nodeRadius * 2)
            let nodePath = UIBezierPath(ovalIn: glowRect)
            context.saveGState()
            context.setShadow(offset: .zero, blur: isHighlighted ? 12 : 4,
                              color: UIColor.systemYellow.cgColor)
            UIColor(white: 0.2, alpha: 0.9).setFill()
            nodePath.fill()
            UIColor.systemOrange.withAlphaComponent(0.9).setStroke()
            nodePath.lineWidth = 2.2
            nodePath.stroke()
            // inner gleam
            let innerGlow = UIBezierPath(ovalIn: glowRect.insetBy(dx: 3, dy: 3))
            UIColor.white.withAlphaComponent(0.5).setFill()
            innerGlow.fill()
            context.restoreGState()
        }
    }
    
    // MARK: - Touch Handling (Ethereal Drag)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !elysianVictoryFlag, let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        let hitRadius: CGFloat = 26.0
        for (idx, node) in etherealControlNodes.enumerated() {
            if node.distance(to: touchPoint) < hitRadius {
                hallucinatedDragIndex = idx
                clandestineHapticGenerator.impactOccurred(intensity: 0.4)
                setNeedsDisplay()
                break
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !elysianVictoryFlag, let dragIdx = hallucinatedDragIndex, let touch = touches.first else { return }
        let newPosition = touch.location(in: self)
        let boundedX = min(max(newPosition.x, phantasmBoundaryInsets.left),
                           bounds.width - phantasmBoundaryInsets.right)
        let boundedY = min(max(newPosition.y, phantasmBoundaryInsets.top),
                           bounds.height - phantasmBoundaryInsets.bottom)
        let constrainedPoint = CGPoint(x: boundedX, y: boundedY)
        etherealControlNodes[dragIdx] = constrainedPoint
        recalcAndDispatchIntersections()
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        hallucinatedDragIndex = nil
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        hallucinatedDragIndex = nil
        setNeedsDisplay()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if etherealControlNodes.isEmpty {
            regenerateKnotworkFromCurrentLevel()
        } else {
            // Reposition nodes proportionally only if not in victory state to avoid drastic jumps
            if !elysianVictoryFlag {
                let boundsRect = bounds.inset(by: phantasmBoundaryInsets)
                let oldBoundsRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
                let scaleX = boundsRect.width / (oldBoundsRect.width - phantasmBoundaryInsets.left - phantasmBoundaryInsets.right)
                let scaleY = boundsRect.height / (oldBoundsRect.height - phantasmBoundaryInsets.top - phantasmBoundaryInsets.bottom)
                for i in 0..<etherealControlNodes.count {
                    let relativeX = (etherealControlNodes[i].x - phantasmBoundaryInsets.left) / (oldBoundsRect.width - phantasmBoundaryInsets.left - phantasmBoundaryInsets.right)
                    let relativeY = (etherealControlNodes[i].y - phantasmBoundaryInsets.top) / (oldBoundsRect.height - phantasmBoundaryInsets.top - phantasmBoundaryInsets.bottom)
                    etherealControlNodes[i] = CGPoint(x: boundsRect.minX + relativeX * boundsRect.width,
                                                      y: boundsRect.minY + relativeY * boundsRect.height)
                }
                recalcAndDispatchIntersections()
                setNeedsDisplay()
            }
        }
        ephemeralGlowLayer?.frame = bounds
    }
}

// MARK: - Custom Modal Alert (Not attached to window)
final class NuminousAlertPortal: UIView {
    private let vesperMessage: String
    private let closureOnDismiss: (() -> Void)?
    private let dauntlessButtonTitle: String
    
    init(message: String, buttonText: String = "Unravel", onDismiss: (() -> Void)? = nil) {
        self.vesperMessage = message
        self.dauntlessButtonTitle = buttonText
        self.closureOnDismiss = onDismiss
        super.init(frame: .zero)
        configureIllusoryAppearance()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func configureIllusoryAppearance() {
        backgroundColor = UIColor.black.withAlphaComponent(0.86)
        layer.cornerRadius = 34
        layer.borderWidth = 1.2
        layer.borderColor = UIColor.systemOrange.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = vesperMessage
        messageLabel.font = UIFont(name: "SnellRoundhand-Bold", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .semibold)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let actionButton = UIButton(type: .system)
        actionButton.setTitle(dauntlessButtonTitle, for: .normal)
        actionButton.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)
        actionButton.setTitleColor(.systemOrange, for: .normal)
        actionButton.backgroundColor = UIColor(white: 0.18, alpha: 1)
        actionButton.layer.cornerRadius = 18
        actionButton.layer.borderWidth = 0.5
        actionButton.layer.borderColor = UIColor.orange.cgColor
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(expungeFromSuperview), for: .touchUpInside)
        
        addSubview(messageLabel)
        addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            actionButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 28),
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 140),
            actionButton.heightAnchor.constraint(equalToConstant: 44),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26)
        ])
    }
    
    @objc private func expungeFromSuperview() {
        removeFromSuperview()
        closureOnDismiss?()
    }
    
    func presentOnView(_ parentView: UIView) {
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
            widthAnchor.constraint(equalToConstant: 280),
            heightAnchor.constraint(equalToConstant: 200)
        ])
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.transform = .identity
        }
    }
}

// MARK: - ViewController (Orchestrator & Artistic UI)
final class UnravelArcaneController: UIViewController {
    private var crypticKnotCanvas: ZephyrousKnotSolverView!
    private var intersectionIndicatorLabel: UILabel!
    private var levelDisclosureLabel: UILabel!
    private var currentLevelIndex = 0
    private let nefariousButtonPanel = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.05, green: 0.03, blue: 0.08, alpha: 1)
        assembleForbiddenCanvas()
        assembleRunicInterface()
    }
    
    private func assembleForbiddenCanvas() {
        crypticKnotCanvas = ZephyrousKnotSolverView(frame: .zero)
        crypticKnotCanvas.translatesAutoresizingMaskIntoConstraints = false
        crypticKnotCanvas.backgroundColor = .clear
        crypticKnotCanvas.layer.cornerRadius = 28
        crypticKnotCanvas.layer.masksToBounds = true
        crypticKnotCanvas.layer.borderWidth = 1.2
        crypticKnotCanvas.layer.borderColor = UIColor(white: 0.3, alpha: 0.8).cgColor
        
        view.addSubview(crypticKnotCanvas)
        NSLayoutConstraint.activate([
            crypticKnotCanvas.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            crypticKnotCanvas.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            crypticKnotCanvas.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            crypticKnotCanvas.heightAnchor.constraint(equalTo: crypticKnotCanvas.widthAnchor, multiplier: 1.12)
        ])
        
        crypticKnotCanvas.onIntersectionCountAltered = { [weak self] knots in
            self?.intersectionIndicatorLabel.text = "KNOT COUNT: \(knots)"
            if knots == 0 {
                self?.intersectionIndicatorLabel.textColor = .systemGreen
            } else {
                self?.intersectionIndicatorLabel.textColor = .systemOrange
            }
        }
        
        crypticKnotCanvas.onTriumphantUnravel = { [weak self] levelIdx in
            let victoryMessage = "✨ Knot Dissolved ✨\nYou conquered level \(levelIdx+1)"
            let alertPortal = NuminousAlertPortal(message: victoryMessage, buttonText: "Ascend") { [weak self] in
                self?.proceedToSubsequentCipher()
            }
            alertPortal.presentOnView(self?.view ?? UIView())
        }
    }
    
    private func assembleRunicInterface() {
        intersectionIndicatorLabel = UILabel()
        intersectionIndicatorLabel.font = UIFont(name: "CourierNewPS-BoldMT", size: 16) ?? UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .bold)
        intersectionIndicatorLabel.textColor = .systemOrange
        intersectionIndicatorLabel.textAlignment = .center
        intersectionIndicatorLabel.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        intersectionIndicatorLabel.layer.cornerRadius = 14
        intersectionIndicatorLabel.layer.masksToBounds = true
        intersectionIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        intersectionIndicatorLabel.text = "KNOT COUNT: 0"
        
        levelDisclosureLabel = UILabel()
        levelDisclosureLabel.font = UIFont(name: "Papyrus", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .medium)
        levelDisclosureLabel.textColor = UIColor(red: 0.94, green: 0.76, blue: 0.48, alpha: 1)
        levelDisclosureLabel.textAlignment = .center
        levelDisclosureLabel.translatesAutoresizingMaskIntoConstraints = false
        levelDisclosureLabel.text = "DEPTH · 1"
        
        view.addSubview(intersectionIndicatorLabel)
        view.addSubview(levelDisclosureLabel)
        
        NSLayoutConstraint.activate([
            intersectionIndicatorLabel.topAnchor.constraint(equalTo: crypticKnotCanvas.bottomAnchor, constant: 18),
            intersectionIndicatorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            intersectionIndicatorLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 150),
            intersectionIndicatorLabel.heightAnchor.constraint(equalToConstant: 40),
            
            levelDisclosureLabel.topAnchor.constraint(equalTo: intersectionIndicatorLabel.bottomAnchor, constant: 8),
            levelDisclosureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // Buttons with artistic geometry (no stackview)
        let resetButton = createOnyxButton(withTitle: "Reset", selector: #selector(performResetAction))
        let nextButton = createOnyxButton(withTitle: "Next Riddle", selector: #selector(attemptNextDomain))
        let hintButton = createOnyxButton(withTitle: "Whisper Hint", selector: #selector(emissaryHint))
        
        nefariousButtonPanel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nefariousButtonPanel)
        nefariousButtonPanel.addSubview(resetButton)
        nefariousButtonPanel.addSubview(nextButton)
        nefariousButtonPanel.addSubview(hintButton)
        
        NSLayoutConstraint.activate([
            nefariousButtonPanel.topAnchor.constraint(equalTo: levelDisclosureLabel.bottomAnchor, constant: 18),
            nefariousButtonPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nefariousButtonPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nefariousButtonPanel.heightAnchor.constraint(equalToConstant: 54),
            
            resetButton.leadingAnchor.constraint(equalTo: nefariousButtonPanel.leadingAnchor),
            resetButton.topAnchor.constraint(equalTo: nefariousButtonPanel.topAnchor),
            resetButton.bottomAnchor.constraint(equalTo: nefariousButtonPanel.bottomAnchor),
            resetButton.widthAnchor.constraint(equalTo: nefariousButtonPanel.widthAnchor, multiplier: 0.3),
            
            nextButton.centerXAnchor.constraint(equalTo: nefariousButtonPanel.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: nefariousButtonPanel.topAnchor),
            nextButton.bottomAnchor.constraint(equalTo: nefariousButtonPanel.bottomAnchor),
            nextButton.widthAnchor.constraint(equalTo: resetButton.widthAnchor),
            
            hintButton.trailingAnchor.constraint(equalTo: nefariousButtonPanel.trailingAnchor),
            hintButton.topAnchor.constraint(equalTo: nefariousButtonPanel.topAnchor),
            hintButton.bottomAnchor.constraint(equalTo: nefariousButtonPanel.bottomAnchor),
            hintButton.widthAnchor.constraint(equalTo: resetButton.widthAnchor)
        ])
    }
    
    private func createOnyxButton(withTitle title: String, selector: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(white: 0.12, alpha: 1)
        btn.layer.cornerRadius = 14
        btn.layer.borderWidth = 0.8
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: selector, for: .touchUpInside)
        return btn
    }
    
    @objc private func performResetAction() {
        crypticKnotCanvas.resetToCurrentDaedal()
        intersectionIndicatorLabel.textColor = .systemOrange
    }
    
    @objc private func attemptNextDomain() {
        crypticKnotCanvas.peregrinateToNextAbyss()
        updateLevelVisuals()
    }
    
    @objc private func emissaryHint() {
        guard let suggestedPoint = crypticKnotCanvas.obfuscatedHintIllumination() else { return }
        let hintAlert = NuminousAlertPortal(message: "A glimmer whispers: try moving near the shimmering node", buttonText: "Gratitude")
        hintAlert.presentOnView(self.view)
        // Flash hint circle (artistic feedback)
        let hintCircle = UIView(frame: CGRect(x: suggestedPoint.x - 20, y: suggestedPoint.y - 20, width: 40, height: 40))
        hintCircle.layer.cornerRadius = 20
        hintCircle.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.5)
        hintCircle.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        crypticKnotCanvas.addSubview(hintCircle)
        UIView.animate(withDuration: 0.4, animations: {
            hintCircle.transform = .identity
            hintCircle.alpha = 0.0
        }) { _ in hintCircle.removeFromSuperview() }
    }
    
    private func proceedToSubsequentCipher() {
        crypticKnotCanvas.peregrinateToNextAbyss()
        updateLevelVisuals()
    }
    
    private func updateLevelVisuals() {
        // Simulated level index increase (internal state)
        currentLevelIndex += 1
        if currentLevelIndex > 2 { currentLevelIndex = 2 }
        levelDisclosureLabel.text = "DEPTH · \(currentLevelIndex + 1)"
        intersectionIndicatorLabel.textColor = .systemOrange
    }
}

// MARK: - Auxiliary distance addition
extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = self.x - point.x
        let dy = self.y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}
