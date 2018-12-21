#
# Janrain podspec
#

Pod::Spec.new do |s|
  s.name          = "Janrain"
  s.version       = "5.1.2"
  s.summary       = "Janrain iOS Mobile Libraries"
  s.homepage      = "https://github.com/janrain/jump.ios"
  s.license       = { :type => 'BSD', :file => 'LICENSE' }
  s.author        = "Janrain"
  s.source        = { :git => "https://github.com/janrain/jump.ios.git", :tag => "5.1.2" }
  s.platform      = :ios, '9.0'
  s.source_files  = "Janrain/**/*.{h,m}"
  s.resources     = ["Janrain/JREngage/Resources/**/*", "Janrain/JREngage/**/*.js"]
  s.requires_arc  = true
  s.pod_target_xcconfig = { "HEADER_SEARCH_PATHS" => "$(PODS_TARGET_SRCROOT)/AppAuth/Source" }
  s.dependency 'AppAuth'
end
