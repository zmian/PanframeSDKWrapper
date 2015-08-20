Pod::Spec.new do |s|
  s.name         = "PanframeSDKWrapper"
  s.version      = "1.0.0"
  s.summary      = "This wrappers makes Panframe iOS SDK play nice with Swift and brings familiar Objctive-C patterns to the SDK"
  s.homepage     = "https://github.com/zmian/PanframeSDKWrapper.git"
  s.license      = { :type => "MIT" }
  s.authors      = { "Zeeshan Mian" => "https://twitter.com/zmian" }
  s.requires_arc = true
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/zmian/PanframeSDKWrapper.git", :tag => "1.0.0"}
  s.source_files = "Source/*.{h,m}"
end
