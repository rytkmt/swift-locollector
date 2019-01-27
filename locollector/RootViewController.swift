//
//  ViewController.swift
//  locollector
//
//  Created by ryo on 2019/01/20.
//  Copyright © 2019 rytkmt. All rights reserved.
//

import UIKit
import MapKit
class RootViewController: UIViewController {
    let sidemenuViewController = SidemenuViewController()
    private var isShownSidemenu: Bool {
        return sidemenuViewController.parent == self
    }
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setCornerRadiusShadow(topBarView)
        setCornerRadiusShadow(addButton, cornerRadius: 25, shadowSize: 2)
        sidemenuViewController.delegate = self
        sidemenuViewController.startPanGestureRecognizing()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func setCornerRadiusShadow(_ view: UIView, cornerRadius: CGFloat = 10, shadowSize: Int = 1) {
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2 // 透明度
        view.layer.shadowOffset = CGSize(width: shadowSize, height: shadowSize) // 距離
        view.layer.shadowRadius = 2 // ぼかし量
    }

    @IBAction func tapListButton(_ sender: Any) {
        showSidemenu(animated: true)
    }

    private func showSidemenu(contentAvailability: Bool = true, animated: Bool) {
        if isShownSidemenu { return }

        addChild(sidemenuViewController)
        sidemenuViewController.view.autoresizingMask = .flexibleHeight
        sidemenuViewController.view.frame = self.navigationController!.view.bounds
        view.insertSubview(sidemenuViewController.view, aboveSubview: self.navigationController!.view)
        sidemenuViewController.didMove(toParent: self)
        if contentAvailability {
            sidemenuViewController.showContentView(animated: animated)
        }
    }

    private func hideSidemenu(animated: Bool) {
        if !isShownSidemenu { return }

        sidemenuViewController.hideContentView(animated: animated, completion: { (_) in
            self.sidemenuViewController.willMove(toParent: nil)
            self.sidemenuViewController.removeFromParent()
            self.sidemenuViewController.view.removeFromSuperview()
        })
    }


}

extension RootViewController: SidemenuViewControllerDelegate {
    func parentViewControllerForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> UIViewController {
        return self
    }

    func shouldPresentForSidemenuViewController(_ sidemenuViewController: SidemenuViewController) -> Bool {
        /* You can specify sidemenu availability */
        return true
    }

    func sidemenuViewControllerDidRequestShowing(_ sidemenuViewController: SidemenuViewController, contentAvailability: Bool, animated: Bool) {
        showSidemenu(contentAvailability: contentAvailability, animated: animated)
    }

    func sidemenuViewControllerDidRequestHiding(_ sidemenuViewController: SidemenuViewController, animated: Bool) {
        hideSidemenu(animated: animated)
    }

    func sidemenuViewController(_ sidemenuViewController: SidemenuViewController, didSelectItemAt indexPath: IndexPath) {
        hideSidemenu(animated: true)
    }
}
