Pod::Spec.new do |s|
  s.name         = 'AFWebViewController'
  s.version      = '1.0'
  s.summary      = 'In-app browser that uses WKWebView'
  s.homepage     = 'https://github.com/Fogh/AFWebViewController'
  s.license      = 'MIT'
  s.author       = { 'Anders Fogh Eriksen' => 'andfogh@gmail.com' }
  s.source       = { :git => 'https://github.com/Fogh/AFWebViewController.git', :tag => s.version.to_s }
  s.platform     = :ios, '8.0'
  s.weak_framework = 'WebKit'
  s.source_files = 'AFWebViewController/*.{h,m}'
  s.resources    = 'AFWebViewController/AFWebViewController.bundle'
  s.social_media_url = 'https://twitter.com/f0gh'
end