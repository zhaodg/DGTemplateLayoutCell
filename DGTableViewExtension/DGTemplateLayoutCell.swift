//
//  DGTemplateLayoutCell.swift
//
//  Created by zhaodg on 11/24/15.
//  Copyright © 2015 zhaodg. All rights reserved.
//

import UIKit

// MARK: - UITableViewCell Extension
extension UITableViewCell {

    // MARK: - public
    public var dg_isTemplateLayoutCell: Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.DGisTemplateLayoutCell) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.DGisTemplateLayoutCell, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    public var dg_enforceFrameLayout: Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.DGenforceFrameLayout) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.DGenforceFrameLayout, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    // MARK: - private
    private struct AssociatedKey {
        static var DGisTemplateLayoutCell = "DGisTemplateLayoutCell"
        static var DGenforceFrameLayout = "DGenforceFrameLayout"
    }
}