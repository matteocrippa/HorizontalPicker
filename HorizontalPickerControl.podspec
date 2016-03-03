#  Be sure to run `pod spec lint HorizontalPicker.podspec' to ensure this is a

Pod::Spec.new do |s|
  s.name         = "HorizontalPickerControl"
  s.version      = "0.1.0"
  s.summary      = "A horizontal picker control for iOS written in Swift."

  s.description  = <<-DESC
A horizontal picker control for iOS written in Swift.
It's a horizontal paged scroll view which allows you to create a slider-style horizontal picker.
Best used for numbers but you can make the option views represent anything you want.

More documentation coming soon.
                   DESC

  s.homepage     = "https://github.com/acrookston/HorizontalPicker"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Andrew Crookston" => "andrew@caoos.com" }
  s.social_media_url   = "http://twitter.com/acr"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/acrookston/HorizontalPicker.git", :tag => "0.1.0" }
  s.source_files = "HorizontalPicker/*.swift"
  s.framework    = "UIKit"
end
