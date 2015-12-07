#
#  Be sure to run `pod spec lint TGPControls.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "TGPControls"
  s.version      = "2.0.0"
  s.summary      = "Custom Awesome iOS Controls: Animated discrete slider, animated labels"

  s.description  = <<-DESC
                   Provide an iOS looking UISlider with discrete, controlable steps
                   Provide dynamic, animated labels for discrete slider
                   Entirely compatible with UISlider

                   DESC

  s.homepage     = "https://github.com/arquebuse/TGPControls"
  s.screenshots  = "https://cloud.githubusercontent.com/assets/4073988/5912371/144aaf24-a588-11e4-9a22-42832eb2c235.gif", "https://cloud.githubusercontent.com/assets/4073988/5912454/15774398-a589-11e4-8f08-18c9c7b59871.gif", "https://cloud.githubusercontent.com/assets/4073988/6628373/183c7452-c8c2-11e4-9a63-107805bc0cc4.gif", "https://cloud.githubusercontent.com/assets/4073988/5912297/c3f21bb2-a586-11e4-8eb1-a1f930ccbdd5.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  # s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "TGPControls_License.txt" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Xavier Schott" => "http://swiftarchitect.com/swiftarchitect/" }
  s.social_media_url = "https://twitter.com/swiftarchitect"


  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios, "7.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/SwiftArchitect/TGPControls.git", :tag => "v2.0.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "TGPControls", "TGPControls/**/*.{h,m}"
  s.exclude_files = "TGPControlsDemo7/*", "TGPControlsDemo/*"
  s.public_header_files = "TGPControls/**/*.{h}"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true


end
