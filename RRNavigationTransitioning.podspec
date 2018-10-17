Pod::Spec.new do |s|
  s.name         = "RRNavigationTransitioning"
  s.version      = "0.1.0"
  s.summary      = "RRNavigationTransitioning helps run interactive navigation transition by screen both sides edge in landscape orientation."

  s.homepage     = "https://github.com/cuzv/RRNavigationTransitioning.git"
  s.license      = "MIT"
  s.author       = { "Shaw" => "cuzval@gmail.com" }
  s.platform     = :ios, "9.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/cuzv/RRNavigationTransitioning.git",
:tag => s.version.to_s }
  s.source_files = "Sources/*.{h,m}"
  s.frameworks   = 'Foundation', 'UIKit'
end
