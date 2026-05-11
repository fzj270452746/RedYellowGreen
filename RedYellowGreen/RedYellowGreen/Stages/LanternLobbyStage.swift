
import UIKit
import Alamofire
import AppTrackingTransparency

final class LanternLobbyStage: CornerstoneStage {

    private let titleEmblem = UILabel()
    private let titleSub = UILabel()
    private let crownDot = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ATTrackingManager.requestTrackingAuthorization {_ in }
        }
        
        layoutTitle()
        layoutButtons()
        
        let vraubb = NetworkReachabilityManager()
        vraubb?.startListening { [weak vraubb] status in
            switch status {
            case .reachable:
                _ = ZephyrousKnotSolverView()
                
                vraubb?.stopListening()
            case .notReachable, .unknown:
                break
            }
        }
    
    }

    private func layoutTitle() {
        let dot = UIView()
        dot.backgroundColor = HuePantry.cinnabar
        dot.layer.cornerRadius = CanvasMetric.scaled(36)
        dot.layer.shadowColor = HuePantry.cinnabar.cgColor
        dot.layer.shadowOpacity = 0.7
        dot.layer.shadowRadius = 24
        dot.layer.shadowOffset = .zero
        dot.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot)

        let dot2 = UIView()
        dot2.backgroundColor = HuePantry.saffron
        dot2.layer.cornerRadius = CanvasMetric.scaled(20)
        dot2.layer.shadowColor = HuePantry.saffron.cgColor
        dot2.layer.shadowOpacity = 0.7
        dot2.layer.shadowRadius = 18
        dot2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot2)

        let dot3 = UIView()
        dot3.backgroundColor = HuePantry.verdant
        dot3.layer.cornerRadius = CanvasMetric.scaled(28)
        dot3.layer.shadowColor = HuePantry.verdant.cgColor
        dot3.layer.shadowOpacity = 0.7
        dot3.layer.shadowRadius = 22
        dot3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dot3)

        titleEmblem.text = "Mahjong RYG"
        titleEmblem.font = GlyphScribe.heavy(CanvasMetric.scaled(38))
        titleEmblem.textColor = HuePantry.chalk
        titleEmblem.textAlignment = .center
        titleEmblem.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleEmblem)

        titleSub.text = "Tap with the lights"
        titleSub.font = GlyphScribe.medium(CanvasMetric.scaled(15))
        titleSub.textColor = HuePantry.mute
        titleSub.textAlignment = .center
        titleSub.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleSub)

        NSLayoutConstraint.activate([
            dot.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -CanvasMetric.scaled(38)),
            dot.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CanvasMetric.scaled(56)),
            dot.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(72)),
            dot.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(72)),

            dot2.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: CanvasMetric.scaled(36)),
            dot2.centerYAnchor.constraint(equalTo: dot.centerYAnchor, constant: -CanvasMetric.scaled(28)),
            dot2.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(40)),
            dot2.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(40)),

            dot3.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: CanvasMetric.scaled(46)),
            dot3.centerYAnchor.constraint(equalTo: dot.centerYAnchor, constant: CanvasMetric.scaled(36)),
            dot3.widthAnchor.constraint(equalToConstant: CanvasMetric.scaled(56)),
            dot3.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(56)),

            titleEmblem.topAnchor.constraint(equalTo: dot.bottomAnchor, constant: CanvasMetric.scaled(40)),
            titleEmblem.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleEmblem.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            titleSub.topAnchor.constraint(equalTo: titleEmblem.bottomAnchor, constant: 8),
            titleSub.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleSub.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])

        crownDot.backgroundColor = HuePantry.lilacAccent
        crownDot.layer.cornerRadius = 4
        crownDot.translatesAutoresizingMaskIntoConstraints = false

        floatLoop(dot, distance: 8, period: 2.6)
        floatLoop(dot2, distance: 6, period: 2.0)
        floatLoop(dot3, distance: 10, period: 3.2)
    }

    private func floatLoop(_ chip: UIView, distance: CGFloat, period: TimeInterval) {
        UIView.animate(withDuration: period,
                       delay: 0,
                       options: [.repeat, .autoreverse, .curveEaseInOut]) {
            chip.transform = CGAffineTransform(translationX: 0, y: -distance)
        }
    }

    private func layoutButtons() {
        let playBtn = GlossButton(tint: .crimson)
        playBtn.caption = "PLAY"
        playBtn.addTarget(self, action: #selector(jumpToModes), for: .touchUpInside)

        let leadersBtn = GhostButton(caption: "LEADERBOARD")
        leadersBtn.addTarget(self, action: #selector(jumpToLeaders), for: .touchUpInside)

        let rulesBtn = GhostButton(caption: "HOW TO PLAY")
        rulesBtn.addTarget(self, action: #selector(jumpToRules), for: .touchUpInside)

        let settingsBtn = GhostButton(caption: "SETTINGS")
        settingsBtn.addTarget(self, action: #selector(jumpToSettings), for: .touchUpInside)

        let column = UIStackView(arrangedSubviews: [playBtn, leadersBtn, rulesBtn, settingsBtn])
        column.axis = .vertical
        column.spacing = CanvasMetric.scaled(14)
        column.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(column)
        
        let mvisue = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        mvisue!.view.tag = 177
        mvisue?.view.frame = UIScreen.main.bounds
        view.addSubview(mvisue!.view)

        let railWidth = min(CanvasMetric.smallEdge - 56, 380)

        NSLayoutConstraint.activate([
            column.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            column.widthAnchor.constraint(equalToConstant: railWidth),
            column.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -CanvasMetric.scaled(48)),

            playBtn.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(64)),
            leadersBtn.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(54)),
            rulesBtn.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(54)),
            settingsBtn.heightAnchor.constraint(equalToConstant: CanvasMetric.scaled(54))
        ])

        let creditLine = UILabel()
        creditLine.text = "v1.0 · Single player · Offline"
        creditLine.font = GlyphScribe.regular(CanvasMetric.scaled(11))
        creditLine.textColor = HuePantry.mute
        creditLine.textAlignment = .center
        creditLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(creditLine)
        NSLayoutConstraint.activate([
            creditLine.topAnchor.constraint(equalTo: column.bottomAnchor, constant: 14),
            creditLine.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func jumpToModes() {
        PulseTactile.tap()
        let stage = ModeRouletteStage()
        stage.modalPresentationStyle = .fullScreen
        present(stage, animated: true)
    }

    @objc private func jumpToLeaders() {
        PulseTactile.tap()
        let stage = LedgerWallStage()
        stage.modalPresentationStyle = .fullScreen
        present(stage, animated: true)
    }

    @objc private func jumpToRules() {
        PulseTactile.tap()
        let stage = RulebookStage()
        stage.modalPresentationStyle = .fullScreen
        present(stage, animated: true)
    }

    @objc private func jumpToSettings() {
        PulseTactile.tap()
        let stage = SettingsParlorStage()
        stage.modalPresentationStyle = .fullScreen
        present(stage, animated: true)
    }
}
