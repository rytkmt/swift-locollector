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

    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setCornerRadiusShadow(topBarView)
        setCornerRadiusShadow(addButton, cornerRadius: 25, shadowSize: 2)
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


}

