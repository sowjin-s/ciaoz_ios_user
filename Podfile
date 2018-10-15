# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'TranxitUser' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

    pod 'Alamofire'
    pod 'KWDrawerController', '~> 4.1.6'
    #pod 'SwiftLint'
    pod 'GoogleMaps'
    pod 'GooglePlaces'
    pod 'lottie-ios'
    pod 'DateTimePicker'
    pod 'PopupDialog', '~> 0.7'
    #pod 'FloatRatingView', '~> 2.0.0'
    #pod 'IQKeyboardManager'
    pod 'Google/SignIn'
    pod 'FBSDKLoginKit'
    pod 'IQKeyboardManagerSwift', '~> 5.0.0'
    pod 'IHKeyboardAvoiding'
    pod 'Fabric', '~> 1.7.7'
    pod 'Crashlytics', '~> 3.10.2'
    pod 'FirebaseAnalytics', '~> 4.0.0'
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'ImagePicker'
    pod 'Lightbox'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'Stripe'
    pod 'CreditCardForm'

  target 'UserTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'UserUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end

end
