//
//  DGFeedCell.swift
//  TemplateLayoutDemo
//
//  Created by zhaodg on 11/26/15.
//  Copyright © 2015 zhaodg. All rights reserved.
//

import UIKit

class DGFeedCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.bounds = UIScreen.mainScreen().bounds
    }

    func loadData(item: DGFeedItem) {
        self.titleLabel.text = item.title
        self.contentLabel.text = item.content
        if item.imageName.characters.count > 0 {
            self.contentImageView.image = UIImage(named: item.imageName)
        }
        self.userNameLabel.text = item.userName
        self.timeLabel.text = item.time
    }

    // If you are not using auto layout, override this method, enable it by setting
    // "fd_enforceFrameLayout" to YES.
    override func sizeThatFits(size: CGSize) -> CGSize {
        var height: CGFloat = 0
        height += self.contentLabel.sizeThatFits(size).height
        height += self.contentLabel.sizeThatFits(size).height
        height += self.contentImageView.sizeThatFits(size).height
        height += self.userNameLabel.sizeThatFits(size).height
        height += self.timeLabel.sizeThatFits(size).height
        return CGSizeMake(size.width, height)
    }

}