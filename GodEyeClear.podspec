Pod::Spec.new do |s|  
  
  s.name         = "GodEyeClear"  
  s.version      = "0.2.0"  
  s.summary      = "A Clear Gods Eye."  
  s.homepage     = "https://github.com/900116/GodEyeClear.git"  
  s.license      = { :type => "MIT", :file => "LICENSE" }  
  s.author       = { "zgh" => "838053527@qq.com" }  
  s.platform     = :ios, "8.0"  
  s.source       = { :git => "https://github.com/900116/GodEyeClear.git", :tag => s.version }  
  s.source_files  = "Classes/**/*"
  s.resource = "Resource/GodEyeClear.bundle"
  s.framework  = "UIKit"  
  s.requires_arc = true   
  s.dependency 'ANREye', '~> 1.1.2'
  s.dependency 'ASLEye', '~> 1.1.1'
  s.dependency 'AppBaseKit', '~> 0.2.2'  
  s.dependency 'AppSwizzle', '~> 1.1.2'
  s.dependency 'AssistiveButton', '~> 1.1.2'
  s.dependency 'CrashEye', '~> 1.1.2'
  s.dependency 'ESPullToRefresh', '~> 2.6'
  s.dependency 'FileBrowser', '~> 0.2.0' 
  s.dependency 'LeakEye', '~> 1.1.3' 
  s.dependency 'Log4G', '~> 0.2.2' 
  s.dependency 'NetworkEye.swift','~> 1.1.3'
  s.dependency 'SwViewCapture','~> 1.0.6'
  s.dependency 'SystemEye','~> 0.2.2'
  s.dependency 'RealmSwift','~> 2.7.0'
  s.dependency 'MJRefresh','~> 3.1.12'

end