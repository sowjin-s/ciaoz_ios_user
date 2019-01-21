# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'

target 'TranxitUser' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

    pod 'Alamofire'
    pod 'GoogleMaps'
    pod 'GoogleSignIn'
    pod 'GooglePlaces'
    pod 'FirebaseAnalytics'
    pod 'Firebase/Database'
    pod 'Firebase/Core'
    pod 'Firebase/Storage'
    pod 'Firebase/Auth'
    pod 'Firebase/Messaging'
    pod 'FacebookCore'
    pod 'FacebookLogin'
    pod 'FacebookShare'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'lottie-ios'
    pod 'IQKeyboardManagerSwift'
    pod 'IHKeyboardAvoiding'
    pod 'KWDrawerController'
    pod 'DateTimePicker'
    pod 'PopupDialog'
#    pod 'ImagePicker'
    pod 'Lightbox'
    pod 'Stripe'
    pod 'AccountKit'
    pod 'DropDown'
    pod 'CreditCardForm', :git => 'https://github.com/orazz/CreditCardForm-iOS', branch: 'master'
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings.delete('CODE_SIGNING_ALLOWED')
          config.build_settings.delete('CODE_SIGNING_REQUIRED')
      end
  end

end
