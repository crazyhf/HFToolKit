Pod::Spec.new do |s|
  s.name         = 'HFToolKit'
  s.version      = '0.0.1'
  s.summary      = 'IOS Tool Kit —— It is just for fun!'
  s.homepage     = 'https://github.com/crazyhf/HFToolKit'
  s.license      = {
      :type => 'GNU General Public License v2.0',
      :file => "LICENSE"
  }
  s.author       = { 'crazylhf' => 'crazylhf@gmail.com' }
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'Include/*', 'Compress/*', 'File/*', 'Http/*', 'Log/*', 'Security/*', 'Services/*', 'TaskQueue/*', 'Wanderers/*'
  s.source       = { :git => 'https://github.com/crazyhf/HFToolKit.git', :tag => 'v#{spec.version}' }
end
