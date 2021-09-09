#
# Be sure to run `pod lib lint XDC3Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XDC3Swift'
  s.version          = '1.3.0'
  s.summary          = 'XinFin API for swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "XinFin Swift API with support for smart contracts and XRC20"

  s.homepage         = 'https://github.com/XinfinLeeway/XDC3Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'XinFin' => 'XFLW@xinfin.org' }
  s.source           = { :git => 'https://github.com/XinfinLeeway/XDC3Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.swift_version = '5.0'
  s.source_files = 'Classes/src/**/*.swift', 'Classes/lib/**/*.{c,h}', 'Classes/src/XRC20/*.swift', 'Classes/src/XRC721/*.swift', 'Classes/src/Account/*.swift', 'Classes/src/Client/*.swift','Classes/src/Contract/*.swift', 'Classes/src/Extensions/*.swift', 'Classes/src/XDCUtils/*.swift'
   s.pod_target_xcconfig = {
     'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]' => '$(PODS_TARGET_SRCROOT)/Classes/lib/**',
     'SWIFT_INCLUDE_PATHS[sdk=iphoneos*]' => '$(PODS_TARGET_SRCROOT)/Classes/lib/**'
   }
   s.preserve_paths = 'Classes/lib/**/module.map'
   s.static_framework = true
  # s.resource_bundles = {
  #   'XDC3Swift' => ['XDC3Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'GenericJSON', '~> 2.0.0'
  s.dependency 'BigInt', '~> 5.2.0'
  s.dependency 'secp256k1.swift', '~> 0.1.0'
  s.dependency 'HDWalletKit', '~> 0.3.6'
end
