source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '8.0'

target 'JWOMPA' do
  use_frameworks!
  pod 'Firebase/Core'
  pod 'Firebase/AdMob'
  pod 'GoogleSignIn'
  pod 'FacebookLogin'
  pod 'AFNetworking','~> 2.5'
  pod 'SDWebImage'
  pod 'Firebase/Messaging'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['DYLIB_COMPATIBILITY_VERSION'] = ''
        end
    end
end
