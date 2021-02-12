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
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo

        if let region = makeMKCoordinateRegion(from: userInfo) {
            mapView.setRegion(region, animated: true)
        }
        
        extensionContext?.notificationActions = [.accept]

        let images = loadImages(from: notification.request.content.attachments)
        imageView.image = images.first
    }

    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {

//        defer { completion(.dismiss) }
//        guard let response = response as? UNTextInputNotificationResponse else {
//            return
//        }
//        let text = response.userText
//        print("User responded with: \(text)")

        defer { completion(.doNotDismiss) }

        let accept = NotificationCategoryActionIdentifier.accept.rawValue
        let cancel = NotificationCategoryActionIdentifier.cancel.rawValue

        switch response.actionIdentifier {
        case accept:
            extensionContext?.notificationActions = [.cancel]
        case cancel:
            extensionContext?.notificationActions = [.accept]
        default:
            break
        }
    }

    // MARK: - Helpers

    private func makeMKCoordinateRegion(from userInfo: [AnyHashable : Any]) -> MKCoordinateRegion? {
        guard let latitude = userInfo["latitude"] as? CLLocationDistance,
              let longitude = userInfo["longitude"] as? CLLocationDistance,
              let radius = userInfo["radius"] as? CLLocationDistance else {
            return nil
        }

        let location = CLLocation(latitude: latitude,
                                  longitude: longitude)

        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: radius,
                                        longitudinalMeters: radius)
        return region
    }

    private func loadImages(from attachments: [UNNotificationAttachment]) -> [UIImage] {
        var images: [UIImage] = []
        attachments.forEach {
            attachment in

            let url = attachment.url

            guard attachment.url.startAccessingSecurityScopedResource() else {
                print("Can not access seccurity scoped resource for: \(url.path)")
                return
            }

            do {
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    images.append(image)
                } else {
                    print("Can not convert data to image for: \(url.path)")
                }
            } catch {
                print("Can not load attachment data for: \(url.path)")
            }
            attachment.url.stopAccessingSecurityScopedResource()
        }
        return images
    }
}
