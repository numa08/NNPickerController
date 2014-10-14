#
# Be sure to run `pod lib lint NNPickerController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "NNPickerController"
  s.version          = "0.9.5"
  s.summary          = "NNPickerController is UI for picking one element."
  s.description      = <<-DESC
                       NNPickerController is UI libary. This interface can select one element, like UIPickerController + UIActionSheet.

                       When ios8, Developer cannot create custom UIActionSheet layout. Now, there can it.
                       DESC
  s.homepage         = "https://github.com/numa08/NNPickerController"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "numa08" => "n511287@gmail.com" }
  s.source           = { :git => "https://github.com/numa08/NNPickerController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/numa08'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'NNPickerController' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
end
