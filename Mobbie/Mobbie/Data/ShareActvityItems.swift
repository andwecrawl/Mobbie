//
//  ShareActvityItems.swift
//  Mobbie
//
//  Created by yeoni on 12/20/23.
//

import LinkPresentation
import UIKit

final class SharePinNumberActivityItemSource: NSObject, UIActivityItemSource {
    private var title: String
    private var content: String
    private var image: UIImage
    
    init(title: String, content: String, image: UIImage) {
        self.title = title
        self.content = content
        self.image = image
        
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return content
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        itemForActivityType activityType: UIActivity.ActivityType?
    ) -> Any? {
        return content
    }
    
    func activityViewController(
        _ activityViewController: UIActivityViewController,
        subjectForActivityType activityType: UIActivity.ActivityType?
    ) -> String {
        return title
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metaData = LPLinkMetadata()
        metaData.title = title
        metaData.iconProvider = NSItemProvider(object: image)
        metaData.originalURL = URL(fileURLWithPath: content)
        return metaData
    }
}
