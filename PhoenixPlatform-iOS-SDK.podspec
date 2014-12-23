Pod::Spec.new do |s|
# warning This podspec is under development

  s.name         = 'PhoenixPlatform-iOS-SDK'
  s.version      = '0.5.29'
  s.license      = 'GPL'
  s.homepage     = 'http://phoenixplatform.com'
  s.authors      =  {'Tigerspike Products' => 'steven.zhang+phoenixsdk@tigerspike.com' }
  s.summary      = 'TSPhoenix is a framework providing access to Tigerspike Phoenix Rest APIs at http://phoenixplatform.com'
  s.source       =  { :git => 'https://github.com/phoenixplatform/phoenix-ios-sdk.git', :tag => s.version }
  s.source_files = 'Source/*.{h,m}', 'Models/**/*.{h,m}', 'Source/Categories/*.{h,m}'
  s.frameworks   = 'SystemConfiguration', 'MobileCoreServices', 'Security'
  
  # platform
  
  s.requires_arc = true
  s.ios.deployment_target = '6.1'
  s.library = 'sqlite3'
  
  # dependencies
  
  s.dependency 'AFNetworking', '~> 2.4.1'
  s.dependency 'AFOAuth2Client@phoenixplatform', '~> 0.1.1'
  s.dependency 'YapDatabase', '~>2.4'
  s.dependency 'ISO8601DateFormatter', '~> 0.7'
end