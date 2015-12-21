Pod::Spec.new do |s|
  s.name         = 'HFToolKit'
  s.version      = '0.0.3'
  s.summary      = 'IOS Tool Kit —— It is just for fun!'
  s.homepage     = 'https://github.com/crazyhf/HFToolKit'
  s.license      = {
      :type => 'GNU General Public License v2.0',
      :file => "LICENSE"
  }
  s.author       = { 'crazylhf' => 'crazylhf@gmail.com' }
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'Include/**/*.h', 'Compress/**/*.{h,m}', 'File/**/*.{h,m}', 'Http/**/*.{h,m}', 'Log/**/*.{h,m}', 'Security/**/*.{h,m}', 'Services/**/*.{h,m}', 'TaskQueue/**/*.{h,m}', 'Wanderers/**/*.{h,m}'
  s.source       = { :git => 'https://github.com/crazyhf/HFToolKit.git', :tag => 'v#{spec.version}' }
end
