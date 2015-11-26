//
//  DGTableViewExtension.swift
//
//  Created by zhaodg on 11/24/15.
//  Copyright © 2015 zhaodg. All rights reserved.
//

import UIKit

// MARK: - UITableView Extension
extension UITableView {

    // MARK: - public method
    public func dg_heightForCellWithIdentifier(identifier: String, configuration: ((cell: UITableViewCell) -> Void)?) -> CGFloat {
        if identifier.characters.count == 0 {
            return 0
        }

        let cell = self.dg_templateCellForReuseIdentifier(identifier)

        // Manually calls to ensure consistent behavior with actual cells (that are displayed on screen).
        cell.prepareForReuse()

        // Customize and provide content for our template cell.
        if configuration != nil {
            configuration!(cell: cell)
        }

        var contentViewWidth: CGFloat = CGRectGetWidth(self.frame)

        // If a cell has accessory view or system accessory type, its content view's width is smaller
        // than cell's by some fixed values.
        if cell.accessoryView != nil {
            contentViewWidth -= 16 + CGRectGetWidth(cell.accessoryView!.frame)
        } else {
            var accessoryWidths: CGFloat?
            switch cell.accessoryType {
            case .None:
                accessoryWidths = 0
            case .DisclosureIndicator:
                accessoryWidths = 34
            case .DetailDisclosureButton:
                accessoryWidths = 68
            case .Checkmark:
                accessoryWidths = 40
            case .DetailButton:
                accessoryWidths = 38
            }
            contentViewWidth -= accessoryWidths!
        }

        var fittingSize: CGSize = CGSizeZero

        if cell.dg_enforceFrameLayout == true {
            // If not using auto layout, you have to override "-sizeThatFits:" to provide a fitting size by yourself.
            // This is the same method used in iOS8 self-sizing cell's implementation.
            // Note: fitting height should not include separator view.
            let selector: Selector = Selector("sizeThatFits:")
            let inherited: Bool = cell.isMemberOfClass(UITableViewCell.self)
            let overrided: Bool = cell.dynamicType.instanceMethodForSelector(selector) != UITableViewCell.instanceMethodForSelector(selector)
            if inherited && !overrided {
                assert(false, "Customized cell must override '-sizeThatFits:' method if not using auto layout.")
            }
            fittingSize = cell.sizeThatFits(CGSizeMake(contentViewWidth, 0))
        } else {
            // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
            // of growing horizontally, in a flow-layout manner.
            let tempWidthConstraint: NSLayoutConstraint = NSLayoutConstraint(item: cell.contentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: contentViewWidth)
            cell.contentView.addConstraint(tempWidthConstraint)

            // Make sure the constraints have been set up for this cell, since it may have just been created from
            // scratch. Use the following lines, assuming you are setting up constraints from within the cell's
            // updateConstraints method:
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()

            // Do the layout pass on the cell, which will calculate the frames for all the views based on the constraints.
            // (Note that you must set the preferredMaxLayoutWidth on multi-line UILabels inside the -[layoutSubviews]
            // method of the UITableViewCell subclass, or do it manually at this point before the below 2 lines!)
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            // Auto layout engine does its math
            fittingSize = cell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
            cell.contentView.removeConstraint(tempWidthConstraint)
        }

        // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
        if self.separatorStyle != .None {
            fittingSize.height += 1.0 / UIScreen.mainScreen().scale
        }

        if cell.dg_enforceFrameLayout == true {
            self.dg_debugLog("calculate using frame layout - \(fittingSize.height)")
        } else {
            self.dg_debugLog("calculate using auto layout - \(fittingSize.height)")
        }

        return fittingSize.height
    }

    public func dg_heightForCellWithIdentifier(identifier: String, key: String, configuration: ((cell: UITableViewCell) -> Void)?) -> CGFloat {
        if identifier.characters.count == 0 || key.characters.count == 0 {
            return 0
        }

        // Hit cache
        if self.dg_keyedHeightCache.existsKey(key) {
            let height: CGFloat = self.dg_keyedHeightCache[key]!
            self.dg_debugLog("hit cache by key[\(key)] -> \(height)")
            return height
        }

        let height = self.dg_heightForCellWithIdentifier(identifier, configuration: configuration)
        self.dg_keyedHeightCache[key] = height
        self.dg_debugLog("cached by key[\(key)] --> \(height)")

        return height
    }

    public func dg_heightForCellWithIdentifier(identifier: String, indexPath: NSIndexPath, configuration: ((cell: UITableViewCell) -> Void)?) -> CGFloat {
        if identifier.characters.count == 0 {
            return 0
        }

        // Hit cache
        if self.dg_indexPathHeightCache.existsIndexPath(indexPath) {
            let height: CGFloat = self.dg_indexPathHeightCache[indexPath]!
            self.dg_debugLog("hit cache by indexPath:[\(indexPath.section),\(indexPath.row)] -> \(height)")
            return height
        }

        let height = self.dg_heightForCellWithIdentifier(identifier, configuration: configuration)
        self.dg_indexPathHeightCache[indexPath] = height
        self.dg_debugLog("cached by indexPath:[\(indexPath.section),\(indexPath.row)] --> \(height)")

        return height
    }


    // MARK: - private
    private func dg_templateCellForReuseIdentifier(identifier: String) -> UITableViewCell {
        assert(identifier.characters.count > 0, "Expect a valid identifier - \(identifier)")
        var templateCell = self.dg_templateCellsByIdentifiers?[identifier] as? UITableViewCell
        if templateCell == nil {
            templateCell = self.dequeueReusableCellWithIdentifier(identifier)
            assert(templateCell != nil, "Cell must be registered to table view for identifier - \(identifier)")
            templateCell?.dg_isTemplateLayoutCell = true
            templateCell?.contentView.translatesAutoresizingMaskIntoConstraints = false
            self.dg_templateCellsByIdentifiers?[identifier] = templateCell
            self.dg_debugLog("layout cell created - \(identifier)")
        }

        return templateCell!
    }

    private struct AssociatedKey {
        static var DGtemplateCellsByIdentifiers = "DGtemplateCellsByIdentifiers"
    }

    private var dg_templateCellsByIdentifiers: [String : AnyObject]? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.DGtemplateCellsByIdentifiers) as? [String : AnyObject]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.DGtemplateCellsByIdentifiers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

// MARK: - UITableView Method Swizzling
extension UITableView {
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }

        // make sure this isn't a subclass
        if self !== UITableView.self {
            return
        }

        dispatch_once(&Static.token) {
            let selectorStrings: [String] = [
                "reloadData",
                "insertSections:withRowAnimation:",
                "deleteSections:withRowAnimation:",
                "reloadSections:withRowAnimation:",
                "moveSection:toSection:",
                "insertRowsAtIndexPaths:withRowAnimation:",
                "deleteRowsAtIndexPaths:withRowAnimation:",
                "reloadRowsAtIndexPaths:withRowAnimation:",
                "moveRowAtIndexPath:toIndexPath:"
            ]

            for selectorString in selectorStrings {
                let originalSelector = Selector(selectorString)
                let swizzledSelector = Selector("dg_"+selectorString)
                let originalMethod = class_getInstanceMethod(self, originalSelector)
                let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }
    }

    // MARK: - Method Swizzling
    public func dg_reloadDataWithoutInvalidateIndexPathHeightCache() {
        self.dg_reloadData()
    }

    public func dg_reloadData() {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.invalidateAllHeightCache()
        }
        self.dg_reloadData()
    }

    public func dg_insertSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.insertSections(sections)
        }
        self.dg_insertSections(sections, withRowAnimation: animation)
    }

    public func dg_deleteSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.deleteSections(sections)
        }
        self.dg_deleteSections(sections, withRowAnimation: animation)
    }

    public func dg_reloadSections(sections: NSIndexSet, withRowAnimation animation: UITableViewRowAnimation) {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.reloadSections(sections)
        }
        self.dg_reloadSections(sections, withRowAnimation: animation)
    }

    public func dg_moveSection(section: Int, toSection newSection: Int) {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.moveSection(section, toSection: newSection)
        }
        self.dg_moveSection(section, toSection: newSection)
    }

    public func dg_insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.insertRowsAtIndexPaths(indexPaths)
        }
        self.dg_insertRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
    }

    public func dg_deleteRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.deleteRowsAtIndexPaths(indexPaths)
        }
        self.dg_deleteRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
    }

    public func dg_reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableViewRowAnimation) {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.reloadRowsAtIndexPaths(indexPaths)
        }
        self.dg_reloadRowsAtIndexPaths(indexPaths, withRowAnimation: animation)
    }

    public func dg_moveRowAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        if self.dg_indexPathHeightCache.automaticallyInvalidateEnabled {
            self.dg_indexPathHeightCache.moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
        }
        self.dg_moveRowAtIndexPath(indexPath, toIndexPath: newIndexPath)
    }
}