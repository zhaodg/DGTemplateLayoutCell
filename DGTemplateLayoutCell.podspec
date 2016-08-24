Pod::Spec.new do |s|
  s.name         = "DGTemplateLayoutCell"
  s.version      = "1.1.2"
  s.summary      = "[Swift 3.0] Template auto layout cell for automatically UITableViewCell height calculate, cache and precache"
  s.description  = "[Swift 3.0] Template auto layout cell for automatically UITableViewCell height calculate, cache and precache. Requires a `self-satisfied` UITableViewCell, using system's `- systemLayoutSizeFittingSize:`, provides heights caching."
  s.homepage     = "https://github.com/zhaodg/DGTemplateLayoutCell"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license = { :type => "MIT", :file => "LICENSE" }
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author = { "zhaodg" => "https://github.com/zhaodg" }
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform = :ios, "8.0"
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source = { :git => "https://github.com/zhaodg/DGTemplateLayoutCell.git", :tag => "v1.1.2" }
  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files  = "DGTableViewExtension/*.{swift}"
  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true
end
