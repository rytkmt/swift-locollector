//
//  ViewController.swift
//  locollector
//
//  Created by ryo on 2019/01/20.
//  Copyright © 2019 rytkmt. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift
class RootViewController: UIViewController {
    
//    let sidemenuViewController = SidemenuViewController()
    let sidemenuViewController = StoryboardBuilder.sharedInstance.sidemenuViewController()
    private var isShownSidemenu: Bool {
        return sidemenuViewController.parent == self
    }
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addButton: UIButton!
    
    var locations: Results<Location>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setCornerRadiusShadow(topBarView)
        setCornerRadiusShadow(addButton, cornerRadius: 25, shadowSize: 2)
        sidemenuViewController.delegate = self
        sidemenuViewController.startPanGestureRecognizing()
        
        self.locations = loadStoredLocations()
        prepareMap()

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
    
    private func prepareMap(){
        for location in self.locations {
            self.dropPin(location)
        }
        pointLocation(self.locations.first)
        
    }
    
    // TODO: DBから取得しループしてすべてをannotationとする
    private func dropPin(_ location: Location) -> CLLocationCoordinate2D{
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        annotation.title = location.title
        mapView.addAnnotation(annotation)
        
        return CLLocationCoordinate2DMake(35.710063, 139.8107)
    }
    
    private func pointLocation(_ location: Location?, delta: Double = 0.03){
        // 倍率を指定 Delta=度 で1度が約111km
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let center: CLLocationCoordinate2D
        if let _location = location {
            center = CLLocationCoordinate2DMake(_location.latitude, _location.longitude)
        }else{
            // pinがなければ大阪駅をデフォルトに
            center = CLLocationCoordinate2DMake(34.702485, 135.495951)
        }
        let region : MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        mapView.region = region
    }
    
    private func loadStoredLocations() -> Results<Location> {
        let realm = try! Realm()
        return realm.objects(Location.self).sorted(byKeyPath: "createdAt", ascending: false)
    }

    @IBAction func tapAddButton(_ sender: Any) {
        let location = Location.create(title: "東京駅", latitude: 35.681236, longitude: 139.767125)
        let realm = try! Realm()
        try! realm.write {
            realm.add(location)
        }
        dropPin(location)
        pointLocation(location)
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
