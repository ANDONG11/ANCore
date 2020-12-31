#
# Be sure to run `pod lib lint ANCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ANCore'
  s.version          = '0.1.5'
  s.summary          = '基础框架'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ANDONG11/ANCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ANDONG11' => 'dongan708@gmail.com' }
  s.source           = { :git => 'https://github.com/ANDONG11/ANCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

#  s.source_files = 'ANCore/Classes/**/*'
  s.source_files = 'ANCore/Classes/ANCore.h'
  
  s.subspec 'Network' do |ss|
      ss.source_files = 'ANCore/Classes/Network/*.{h,m}'
      ss.dependency 'AFNetworking'
  end
  
  s.subspec 'Router' do |ss|
      ss.source_files = 'ANCore/Classes/Router/*.{h,m}'
  end
  
  s.subspec 'Utils' do |ss|
      ss.source_files = 'ANCore/Classes/Utils/*.{h,m}'
  end
  
  s.subspec 'CrashGuard' do |ss|
      ss.source_files = 'ANCore/Classes/CrashGuard/*.{h,m}'
  end
  
  # s.resource_bundles = {
  #   'ANCore' => ['ANCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit','objc/runtime.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end


