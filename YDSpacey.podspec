#
#  Be sure to run `pod spec lint YDSpacey.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "YDSpacey"
  spec.version      = "1.4.7"
  spec.summary      = "A short description of YDSpacey."

  spec.homepage     = "https://yourdev.com.br"
  spec.license      = "MIT"
  spec.author       = { "Douglas Hennrich" => "douglashennrich@yourdev.com.br" }

  spec.swift_version = "5.0"
  spec.platform     = :ios, "11.0"
  spec.source       = {
    :git => "git@github.com:Hennrich-Your-Dev/YDSpacey.git",
    :tag => "#{spec.version}"
  }

  ##
  spec.source_files = "YDSpacey/**/*.{h,m,swift}"
  spec.resources = ["YDSpacey/**/*.json"]

  ##
  spec.dependency "Cosmos", "22.1.0"
  spec.dependency "YDB2WModels", "~> 1.4.0"
  spec.dependency "YDExtensions", "~> 1.4.0"
  spec.dependency "YDUtilities", "~> 1.4.0"
  spec.dependency "YDB2WServices", "~> 1.4.0"
  spec.dependency "YDB2WAssets", "~> 1.4.0"
  spec.dependency "YDB2WComponents", "~> 1.4.0"
end
