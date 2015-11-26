# DGTemplateLayoutCell (Swift 2.0)
Template auto layout cell for automatically UITableViewCell height calculating.(**Swift 2.0**)

> DGTemplateLayoutCell copy and modify forkingdog's [UITableView-FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell), and it is implemented in Swift2.0.

## Overview
Template auto layout cell for **automatically** UITableViewCell height calculating.

![Demo Overview](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell/blob/master/Sceenshots/zhaodg.gif)

## Basic usage

If you have a **self-satisfied** cell, then all you have to do is: 

``` 
override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return tableView.dg_heightForCellWithIdentifier("DGFeedCell", configuration: { (cell) -> Void in
    // Configure this cell with data, same as what you've done in "-tableView:cellForRowAtIndexPath:"
    // Like:
    //    let cell = cell as! DGFeedCell
    //    cell.loadData(self.feedList[indexPath.section][indexPath.row])
    })
}
```

## Height Caching API

Since iOS8, `-tableView:heightForRowAtIndexPath:` will be called more times than we expect, we can feel these extra calculations when scrolling. So we provide another API with cache by index path:   

``` 
override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return tableView.dg_heightForCellWithIdentifier("DGFeedCell", indexPath: indexPath, configuration: { (cell) -> Void in
    // Configure this cell with data, same as what you've done in "-tableView:cellForRowAtIndexPath:"
    // Like:
    //    let cell = cell as! DGFeedCell
    //    cell.loadData(self.feedList[indexPath.section][indexPath.row])
    })
}
```

Or, if your entity has an unique identifier, use cache by key API:

``` 
override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return tableView.dg_heightForCellWithIdentifier("DGFeedCell", key: uuid, configuration: { (cell) -> Void in
    // Configure this cell with data, same as what you've done in "-tableView:cellForRowAtIndexPath:"
    // Like:
    //    let cell = cell as! DGFeedCell
    //    cell.loadData(self.feedList[indexPath.section][indexPath.row])
    })
}
```

## Frame layout mode

`FDTemplateLayoutCell` offers 2 modes for asking cell's height.  

1. Auto layout mode using "-systemLayoutSizeFittingSize:"  
2. Frame layout mode using "-sizeThatFits:"  

Generally, no need to care about modes, it will **automatically** choose a proper mode by whether you have set auto layout constrants on cell's content view. If you want to enforce frame layout mode, enable this property in your cell's configuration block:  

``` 
cell.dg_enforceFrameLayout = true
```
And if you're using frame layout mode, you must override `-sizeThatFits:` in your customized cell and return content view's height (separator excluded)

```
override func sizeThatFits(size: CGSize) -> CGSize {
    // var height: CGFloat = 0
    // height += self.contentLabel.sizeThatFits(size).height
    // height += self.contentLabel.sizeThatFits(size).height
    // height += self.contentImageView.sizeThatFits(size).height
    // height += self.userNameLabel.sizeThatFits(size).height
    // height += self.timeLabel.sizeThatFits(size).height
    return CGSizeMake(size.width, height)
}

```

## Debug log

Debug log helps to debug or inspect what is this "FDTemplateLayoutCell" extention doing, turning on to print logs when "calculating", "precaching" or "hitting cache".Default to "false", log by "print".

```
self.tableView.dg_debugLogEnabled = true
```

It will print like this:  

``` 
calculate using auto layout - 388.666666666667
cached by indexPath:[0,4] --> 388.666666666667
layout cell created - DGFeedCell
calculate using auto layout - 338.666666666667
cached by indexPath:[0,5] --> 338.666666666667
layout cell created - DGFeedCell
calculate using auto layout - 371.666666666667
cached by indexPath:[0,6] --> 371.666666666667
layout cell created - DGFeedCell
calculate using auto layout - 242.333333333333
cached by indexPath:[0,7] --> 242.333333333333
hit cache by indexPath:[0,0] -> 125.333333333333
hit cache by indexPath:[0,0] -> 125.333333333333
hit cache by indexPath:[0,1] -> 147.0
hit cache by indexPath:[0,1] -> 147.0
hit cache by indexPath:[0,2] -> 352.0
hit cache by indexPath:[0,2] -> 352.0
```

## About self-satisfied cell

a fully **self-satisfied** cell is constrainted by auto layout and each edge("top", "left", "bottom", "right") has at least one layout constraint against it. It's the same concept introduced as "self-sizing cell" in iOS8 using auto layout.

A bad one :( - missing right and bottom
![non-self-satisfied](https://github.com/zhaodg/DGTemplateLayoutCell/blob/master/Sceenshots/screenshot0.png)   

A good one :)  
![self-satisfied](https://github.com/zhaodg/DGTemplateLayoutCell/blob/master/Sceenshots/screenshot1.png)   

## Notes

A template layout cell is created by `-dequeueReusableCellWithIdentifier:` method, it means that you MUST have registered this cell reuse identifier by one of:  

- A prototype cell of UITableView in storyboard.
- Use `-registerNib:forCellReuseIdentifier:` 
- Use `-registerClass:forCellReuseIdentifier:`

## 如果你在天朝
原作者(**sunnyxx**）文章： 
[http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/](http://blog.sunnyxx.com/2015/05/17/cell-height-calculation/)

## Installation

Latest version: **1.0**

```
pod search DGTemplateLayoutCell 
```
If you cannot search out the latest version, try:  

```
pod setup
```

## Release Notes

We recommend to use the latest release in cocoapods.

- 1.0 
> 1. Modify [FDTemplateLayoutCell](https://github.com/forkingdog/UITableView-FDTemplateLayoutCell) 
> 2. Writes in Swift 2.0

## License
MIT
