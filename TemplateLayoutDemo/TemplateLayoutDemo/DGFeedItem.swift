//
//  DGFeedItem.swift
//  TemplateLayoutDemo
//
//  Created by zhaodg on 11/26/15.
//  Copyright © 2015 zhaodg. All rights reserved.
//

import Foundation

var countDGFeedItemIdentifier: Int = 1

struct DGFeedItem {

    var identifier: String
    let title: String
    let content: String
    let userName: String
    let time: String
    let imageName: String

    init(dict: NSDictionary) {
        countDGFeedItemIdentifier += 1
        identifier = "unique_id_\(countDGFeedItemIdentifier)"
//            dict["identifier"] as! String
        title = dict["title"] as! String
        content = dict["content"] as! String
        userName = dict["username"] as! String
        time = dict["time"] as! String
        imageName = dict["imageName"] as! String
    }
}