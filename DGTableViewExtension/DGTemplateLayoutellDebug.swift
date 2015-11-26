//
//  DGTemplateLayoutellDebug.swift
//
//  Created by zhaodg on 11/24/15.
//  Copyright © 2015 zhaodg. All rights reserved.
//

import UIKit

// MARK: - UITableView Extension
extension UITableView {

    var dg_debugLogEnabled: Bool? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.DGdebugLogEnabled) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.DGdebugLogEnabled, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    // MARK: - public method
    public func dg_debugLog(message: String) {
        if self.dg_debugLogEnabled == true {
            print(message)
        }
    }

    // MARK: - private
    private struct AssociatedKey {
        static var DGdebugLogEnabled = "DGdebugLogEnabled"
    }
}
