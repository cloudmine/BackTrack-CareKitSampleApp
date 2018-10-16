platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'BackTrack' do
  use_frameworks!

  pod 'CMHealth', :git => 'git@github.com:cloudmine/CMHealthSDK-iOS.git'

  target 'BackTrackTests' do
    inherit! :search_paths
  end

  target 'BackTrackUITests' do
    inherit! :search_paths
  end
end
