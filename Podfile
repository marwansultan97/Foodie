# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Foodie' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks! :linkage => :static

  pod 'Alamofire'
  pod 'SDWebImage', '~> 5.0'
  pod 'AMPopTip'
  pod 'MaterialComponents/Chips'
  pod 'ChameleonFramework/Swift'
  pod 'DropDown'
  pod 'SideMenuSwift'
  pod "DynamicBlurView"

end


post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
  end
 end
end
