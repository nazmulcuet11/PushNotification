//
//  NotificationService.swift
//  NSE
//
//  Created by Nazmul's Mac Mini on 12/2/21.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {

        print(#function)
        print(request.content.userInfo)

        guard let bestAttemptContent = request.content.mutableCopy() as? UNMutableNotificationContent else {
            contentHandler(request.content)
            return
        }

        self.contentHandler = contentHandler
        self.bestAttemptContent = bestAttemptContent

        // Modify the notification content here...
        bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"

        // Increment badge
        if let incr = bestAttemptContent.badge as? Int {
            let current = UserDefaults.apppGroup.badge
            let new = current + incr

            UserDefaults.apppGroup.badge = new
            bestAttemptContent.badge = NSNumber(value: new)
        }

        // create attachments
        createMediaAttachment(from: request.content.userInfo) {
            attachment in

            if let attachment = attachment {
                bestAttemptContent.attachments = [attachment]
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    // MARK: - Helpers
    private func createMediaAttachment(from  userInfo: [AnyHashable : Any],
                                       completion: @escaping (UNNotificationAttachment?) -> Void) {

        guard let urlPath = userInfo["media-url"] as? String,
          let url = URL(string: urlPath) else {
          completion(nil)
          return
        }

        downloadMedia(with: url) {
            localFileURL, error in

            var attachment: UNNotificationAttachment?
            defer { completion(attachment) }

            if let error = error {
                print("Can not download media for: \(url.path), error: \(error.localizedDescription)")
                return
            }

            guard let localFileURL = localFileURL else {
                print("Not local url found")
                return
            }

            do {
                attachment = try UNNotificationAttachment(
                    identifier: "",
                    url: localFileURL
                )
            } catch {
                print("Can not create attachment for: \(url.path)")
            }
        }
    }

    private func downloadMedia(with url: URL,
                               completion: @escaping (URL?, Error?) -> Void) {

        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in

            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "NSE_ERROR", code: 1001, userInfo: ["message": "No Data"]))
                return
            }

            let destination = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(response?.suggestedFilename ?? url.lastPathComponent)

            do {
                try data.write(to: destination)
                completion(destination, nil)
            } catch {
                print("Failed to write data to: \(destination.path), error: \(error.localizedDescription)")
                completion(nil, error)
            }
        }

        task.resume()
    }
}
