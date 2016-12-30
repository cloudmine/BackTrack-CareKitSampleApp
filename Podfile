platform :ios, '9.0'

target 'BackTrack' do
  use_frameworks!

  pod 'CMHealth', :path => '../cmhealth-beta-private'
  pod 'CareKit', :path => '../carekit-beta-private'
  pod 'ResearchKit', :git => 'https://github.com/ResearchKit/ResearchKit'

  target 'BackTrackTests' do
    inherit! :search_paths
  end

  target 'BackTrackUITests' do
    inherit! :search_paths
  end
end
