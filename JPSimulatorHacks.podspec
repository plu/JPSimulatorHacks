Pod::Spec.new do |s|
  s.name         = 'JPSimulatorHacks'
  s.version      = '1.3.0'
  s.license      = 'MIT'
  s.summary      = 'Hack the Simulator in your tests (grant access to photos, contacts, ...)'
  s.homepage     = 'https://github.com/plu/JPSimulatorHacks'
  s.authors      = { 'Johannes Plunien' => 'plu@pqpq.de' }
  s.source       = { :git => 'https://github.com/plu/JPSimulatorHacks.git', :tag => s.version.to_s }
  s.requires_arc = true

  s.ios.deployment_target = '7.0'
  s.source_files = 'JPSimulatorHacks/*.{h,m}'
  s.library = 'sqlite3'
end
