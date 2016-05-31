platform :ios, '9.0'

target 'BackTrack' do
  use_frameworks!

  pod "CloudMine", "~> 1.7.11"
  pod "ResearchKit", "~> 1.3.1"
  pod "CareKit", "~> 1.0"
  pod "CMHealth", :git => "https://github.com/cloudmine/CMHealthSDK-iOS.git"

  target 'BackTrackTests' do
    inherit! :search_paths
  end

  target 'BackTrackUITests' do
    inherit! :search_paths
  end
end
