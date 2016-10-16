# Uncomment this line to define a global platform for your project
platform :ios, ‘10.0’
# Uncomment this line if you're using Swift
use_frameworks!

target ‘Onion Apps’ do

pod 'Alamofire', '~> 4.0'
pod 'moa', '~> 8.0'
pod 'Auk', '~> 7.0'
pod "SwiftSpinner"
pod 'pop', '~> 1.0'
pod 'IQKeyboardManagerSwift', '4.0.6'
pod 'SideMenu'
pod 'Firebase'
pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'Firebase/Core'
pod 'Firebase/Messaging'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
