
Pod::Spec.new do |s|

  s.name         = "DYFAuthIDAndGestureLock"
  s.version      = "1.0.2"
  s.summary      = "Gesture passcode and TouchID/FaceID unlocking."
  s.description  = <<-DESC
	Gesture passcode unlocking and TouchID (fingerprint) / FaceID (facial features) unlocking, its code is concise and efficient.
                   DESC

  s.homepage     = "https://github.com/dgynfi/DYFAuthIDAndGestureLock"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "dyf" => "vinphy.teng@foxmail.com" }

  s.platform     = :ios
  s.ios.deployment_target 	= "8.0"
  # s.osx.deployment_target 	= "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target 	= "9.0"

  s.source       = { :git => "https://github.com/dgynfi/DYFAuthIDAndGestureLock.git", :tag => s.version.to_s }

  s.source_files  = "Classes/**/*.{h,m}"
  s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  s.resources = "Resource/*.bundle"

  s.frameworks = "Foundation", "UIKit", "LocalAuthentication", "QuartzCore"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
