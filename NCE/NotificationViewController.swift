//
//  NotificationViewController.swift
//  NCE
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MapKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo

        guard let latitude = userInfo["latitude"] as? CLLocationDistance,
              let longitude = userInfo["longitude"] as? CLLocationDistance,
              let radius = userInfo["radius"] as? CLLocationDistance else {
            return
        }

        let location = CLLocation(latitude: latitude,
                                  longitude: longitude)

        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: radius,
                                        longitudinalMeters: radius)

        mapView.setRegion(region, animated: true)
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {

        defer { completion(.dismiss) }

        guard let response = response as? UNTextInputNotificationResponse else {
            return
        }

        let text = response.userText
        print("User responded with: \(text)")
    }
}
