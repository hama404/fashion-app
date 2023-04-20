//
//  ShareViewController.swift
//  storage-share
//
//  Created by 浜崎優一 on 2023/04/16.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {
  
  override func isContentValid() -> Bool {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return true
  }
  
  override func didSelectPost() {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

    guard let extensionItem: NSExtensionItem = extensionContext?.inputItems.first as? NSExtensionItem, let itemProviders = extensionItem.attachments else { return }
    let identifier = "public.url"
    let urlProvider = itemProviders.first(where: { $0.hasItemConformingToTypeIdentifier(identifier)})
    urlProvider?.loadItem(forTypeIdentifier: identifier, options: nil, completionHandler: { [weak self] (item, error) in
      guard let url = item as? URL else { return }

      print("hello post!!", url)
      createShareData(url: url)

    })

    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
  }
  
  override func configurationItems() -> [Any]! {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return []
  }
  
}
