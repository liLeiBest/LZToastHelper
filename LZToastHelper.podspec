
Pod::Spec.new do |s|
  s.name             = 'LZToastHelper'
  s.version          = '0.1.1'
  s.summary          = 'A short description of LZToastHelper.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lilei_hapy@163.com/LZToastHelper'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lilei_hapy@163.com' => 'lilei_hapy@163.com' }
  s.source           = { :git => 'https://github.com/liLeiBest/LZToastHelper.git', :tag => s.version.to_s }

  s.frameworks            = 'Foundation', 'UIKit'
  s.ios.deployment_target = '8.0'
  
  s.source_files 	   	= 'LZToastHelper/Classes/*.{h,m}'
  s.public_header_files = 'LZToastHelper/Classes/*.h'
  s.resource = 'LZToastHelper/Classes/LZToastResource.bundle'
  s.dependency 'MBProgressHUD'
  
end
