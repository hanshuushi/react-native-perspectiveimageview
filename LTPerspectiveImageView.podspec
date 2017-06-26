
Pod::Spec.new do |s|
  s.name             = 'LTPerspectiveImageView'
  s.version          = '0.2.3'
  s.summary          = 'hollowoutlabel effect for react native'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/hanshuushi/react-native-perspectiveimageview.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Han Shuushi' => 'hanshuushi@gmail.com' }
  s.source           = { :git => 'https://github.com/hanshuushi/react-native-perspectiveimageview.git', :tag => s.version.to_s }
  s.source_files    = 'LTPerspectiveImageView/*.{h,m}'
  s.ios.deployment_target = '7.0'
  s.dependency 'React'
end
