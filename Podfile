# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'ChronoCanvas' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ChronoCanvas
  pod 'Google-Mobile-Ads-SDK'

end

# Pods の古いデプロイメントターゲットが最新の Xcode でビルドエラーになるため、アプリに揃える
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 15.0
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
