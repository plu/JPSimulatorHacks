Pod::Spec.new do |s|
  s.name         = 'JPSimulatorHacks'
  s.version      = '1.4.0'
  s.license      = 'MIT'
  s.summary      = 'Hack the Simulator in your tests (grant access to photos, contacts, ...)'
  s.homepage     = 'https://github.com/plu/JPSimulatorHacks'
  s.authors      = { 'Johannes Plunien' => 'plu@pqpq.de' }
  s.source       = { :git => 'https://github.com/plu/JPSimulatorHacks.git', :tag => s.version.to_s }
  s.requires_arc = true
  s.ios.deployment_target = '7.0'
  s.default_subspec = 'standard'  

  s.subspec 'standard' do |ss|
    ss.source_files = 'JPSimulatorHacks/*.{h,m}'
    ss.library = 'sqlite3'
  end

  s.subspec 'standalone' do |ss|
    ss.xcconfig = { 'OTHER_CFLAGS' => '$(inherited) -DJPSH_SQLITE_STANDALONE' }
    ss.source_files = 'JPSimulatorHacks/*.{h,m}'
    ss.dependency 'sqlite3'
  end

end
