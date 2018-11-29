platform :ios, '9.0'
use_frameworks!

target 'Flash Chat' do
  pod 'Firebase/Core'
  pod 'SVProgressHUD'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'ChameleonFramework'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
    end
end
