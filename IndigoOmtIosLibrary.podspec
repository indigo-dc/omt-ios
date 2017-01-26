#
# Be sure to run `pod lib lint IndigoOmtIosLibrary.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name                = 'IndigoOmtIosLibrary'
  s.version             = '0.1.0'
  s.cocoapods_version   = '>= 1.1.1'
  s.summary             = 'iOS library which simplifies access to INDIGO DataCloud API.'
  s.description         = <<-DESC
iOS library which simplifies access to INDIGO DataCloud API.
For more information visit https://github.com/indigo-dc
                        DESC

  s.homepage            = 'https://github.com/indigo-dc/omt-ios'
  s.license             = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.author              = { 'Sebastian Mamczak' => 'smamczak@man.poznan.pl' }
  s.source              = { :git => 'https://github.com/indigo-dc/omt-ios.git', :tag => s.version }

  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.source_files = 'IndigoOmtIosLibrary/Classes/**/*'
  s.dependency 'AppAuth'
  s.dependency 'Alamofire'
  s.dependency 'SwiftyJSON'

end
