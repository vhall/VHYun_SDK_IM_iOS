Pod::Spec.new do |s|
  s.name            = "VHYun_IM"
  s.version         = "2.3.4"
  s.author          = { "chao.guo" => "chao.guo@vhall.com" }
  s.license         = { :type => "MIT", :file => "LICENSE" }
  s.homepage        = 'https://www.vhall.com'
  s.source          = { :git => "https://github.com/vhall/VHYun_SDK_IM_iOS.git", :tag => s.version.to_s}
  s.summary         = "iOS IM framework"
  s.platform        = :ios, '9.0'
  s.requires_arc    = true
  #s.source_files    = ''
  s.frameworks      = 'Foundation'
  s.module_name     = 'VHYun_IM'
  s.resources       = ['README.md']
  #s.resource_bundles= {}
  s.vendored_frameworks = 'VHYunFrameworks/*.framework'
  s.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'VALID_ARCHS' => 'x86_64 i386 armv7 arm64'
  }

  s.dependency 'VHCore','>=2.3.8'
end
