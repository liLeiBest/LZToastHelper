
Pod::Spec.new do |s|
  s.name             = 'LZToastHelper'
  s.version          = '0.1.6'
  s.summary          = '基于 MBProgressHUD 进行二次封装。'
  s.description      = <<-DESC
  Toast 飘窗提醒
  1.单例
  2.全局统一配置
  3.隐藏统一回调
                       DESC

  s.homepage         = 'https://github.com/liLeiBest'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lilei_hapy@163.com' => 'lilei_hapy@163.com' }
  s.source           = { :git => 'https://github.com/liLeiBest/LZToastHelper.git', :tag => s.version.to_s }

  s.frameworks            = 'Foundation', 'UIKit'
  s.ios.deployment_target = '8.0'
  
  s.source_files 	   	= 'LZToastHelper/Classes/*.{h,m}'
  s.public_header_files = 'LZToastHelper/Classes/*.h'
  s.dependency 'MBProgressHUD'
  
end
