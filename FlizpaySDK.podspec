Pod::Spec.new do |s|
  s.name             = 'FlizpaySDK'
  s.version          = '0.2.2'
  s.summary          = 'Flizpay iOS SDK'
  s.description      = 'iOS SDK for integrating Flizpay payment services'
  s.homepage         = 'https://github.com/Flizpay/flizpay-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Flizpay' => 'carlos.cunha@flizpay.de' }
  s.source           = { :git => 'https://github.com/Flizpay/flizpay-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'Sources/FlizpaySDK/**/*'
end
