Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "TGPControls"
  spec.version      = "4.0.1"
  spec.summary      = "Custom animated iOS controls: Animated discrete slider, animated labels"

  spec.description  = <<-DESC
                   Provide an iOS looking UISlider with discrete, controlable steps
                   Provide dynamic, animated labels for discrete slider
                   Entirely compatible with UISlider
                   DESC
  spec.homepage     = "https://github.com/SwiftArchitect/TGPControls"
  spec.screenshots  = "https://cloud.githubusercontent.com/assets/4073988/5912371/144aaf24-a588-11e4-9a22-42832eb2c235.gif", "https://cloud.githubusercontent.com/assets/4073988/5912454/15774398-a589-11e4-8f08-18c9c7b59871.gif", "https://cloud.githubusercontent.com/assets/4073988/6628373/183c7452-c8c2-11e4-9a63-107805bc0cc4.gif", "https://cloud.githubusercontent.com/assets/4073988/5912297/c3f21bb2-a586-11e4-8eb1-a1f930ccbdd5.gif"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "Xavier Schott" => "http://swiftarchitect.com/swiftarchitect/" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.requires_arc = true

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/SwiftArchitect/TGPControls.git", :tag => "v4.0.1" }
  spec.source_files = "TGPControls/**/*.{swift}"
  spec.exclude_files = "TGPControlsDemo/*"

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.framework = "UIKit"

end
