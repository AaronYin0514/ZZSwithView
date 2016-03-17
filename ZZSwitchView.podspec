Pod::Spec.new do |s|
s.name     = 'ZZSwitchView'
s.version  = '1.0.0'
s.license  = 'MIT'
s.summary  = 'A delightful iOS UI control.'
s.homepage = 'https://github.com/AaronYin0514'
s.authors  = { 'Aaron' => '562540603@qq.com' }
s.source   = { :git => 'https://github.com/AaronYin0514/ZZSwithView.git', :tag => s.version }
s.requires_arc = true
s.framework = 'UIKit'
s.source_files = 'ZZSwitchItem/*.{h,m}'
end