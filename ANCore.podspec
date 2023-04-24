#
# Be sure to run `pod lib lint ANCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ANCore'
  s.version          = '0.8.2'
  s.summary          = '基础框架'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ANDONG11/ANCore'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ANDONG11' => 'dongan708@gmail.com' }
  s.source           = { :git => 'https://github.com/ANDONG11/ANCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'


  s.source_files = 'ANCore/Classes/ANCore.h'

  s.dependency 'MBProgressHUD'
  
  s.subspec 'Network' do |ss|
      ss.source_files = 'ANCore/Classes/Network/*.{h,m}'
      ss.dependency 'AFNetworking'
  end
  
  s.subspec 'Router' do |ss|
      ss.source_files = 'ANCore/Classes/Router/*.{h,m}'
      ss.subspec 'Handler' do |r|
          r.source_files = 'ANCore/Classes/Router/Handler/*.{h,m}'
      end
  end
  
  s.subspec 'Utils' do |ss|
      ss.source_files = 'ANCore/Classes/Utils/*.{h,m}'
  end
  
  s.subspec 'CrashGuard' do |ss|
      ss.source_files = 'ANCore/Classes/CrashGuard/*.{h,m}'
  end
  
  s.subspec 'Category' do |ss|
      ss.source_files = 'ANCore/Classes/Category/*.{h,m}'
      ss.dependency 'MJRefresh'
  end
  
  s.subspec 'UI' do |ss|
      ss.source_files = 'ANCore/Classes/UI/*.{h,m}'
      ss.dependency 'ANCore/Category'
      ss.dependency 'ANCore/Macros'
  end
  
  s.subspec 'Macros' do |ss|
      ss.source_files = 'ANCore/Classes/Macros/*.{h,m}'
  end
  
  s.subspec 'OpenShareManager' do |ss|
      ss.source_files = 'ANCore/Classes/OpenShareManager/*.{h,m}'
  end
  
  # s.resource_bundles = {
  #   'ANCore' => ['ANCore/Assets/*.png']
  # }

   s.public_header_files = 'Pod/Classes/ANCore.h'
#   s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end


