platform :ios, '9.0'

target 'BackTrack' do
  use_frameworks!

  pod 'CMHealth', :git => 'https://github.com/apbendi/CMHealthSDK-iOS.git', :branch => 'carekit'
  #pod "CMHealth", :path => "../CMHealthSDK-iOS/"

  target 'BackTrackTests' do
    inherit! :search_paths
  end

  target 'BackTrackUITests' do
    inherit! :search_paths
  end
end
