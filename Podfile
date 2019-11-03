# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def network
  pod 'Alamofire', '~> 4.8.1'
  pod 'AlamofireImage', '~> 3.5'

end

target 'RelaxMeMac' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  network
  # Pods for RelaxMeMac
  pod 'CryptoSwift'
  pod 'Hue'

  target 'RelaxMeMacTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RelaxMeMacUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
