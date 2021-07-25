#
#  Be sure to run `pod spec lint EmojiPicker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "GEmojiPicker"
  spec.version      = "1.0.0"
  spec.swift_version = "5.0"
  spec.summary      = "iOS & MacOS Emoji Picker"
  spec.description  = "SwiftUI iOS & MacOS Emoji Picker"

  spec.homepage     = "https://github.com/Goeun1001/GEmojiPicker"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Goeun1001" => "gogo8272@gmail.com" }
  spec.ios.deployment_target = '14.0'
  spec.osx.deployment_target = '11.0'
  spec.ios.source_files   = 'Sources/GEmojiPicker/iOS/*.swift'
  spec.osx.source_files   = 'Sources/GEmojiPicker/OSX/*.swift'
  spec.ios.framework  = 'UIKit'
  spec.osx.framework  = 'AppKit'
  spec.source       = { :git => "https://github.com/Goeun1001/GEmojiPicker.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/*", "Sources/**/*"
  
end
