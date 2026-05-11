//
//  CornerstoneStage.swift
//  Base view controller with shared backdrop.
//

import UIKit

class CornerstoneStage: UIViewController {

    let backdrop = GradientPlate()
    let starfield = StarfieldBackdrop()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = HuePantry.voidShade

        backdrop.palette = [HuePantry.voidShade, HuePantry.abyssShade, HuePantry.twilightShade]
        backdrop.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backdrop)

        starfield.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starfield)

        NSLayoutConstraint.activate([
            backdrop.topAnchor.constraint(equalTo: view.topAnchor),
            backdrop.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backdrop.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdrop.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            starfield.topAnchor.constraint(equalTo: view.topAnchor),
            starfield.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            starfield.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            starfield.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }

    override var prefersStatusBarHidden: Bool { false }
}
