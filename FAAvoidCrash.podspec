Pod::Spec.new do |s|

    s.name         = "FAAvoidCrash"
    s.platform = :ios, "13.0"
    s.description      = <<-DESC
            Avoid the Crash
                       DESC
    s.version      = "1.0.0"
    s.ios.deployment_target = '13.0'
    s.summary      = "This framework can avoid Foundation framework potential crash danger"
    s.homepage     = "https://github.com/ios002uuu/FAAvoidCrash"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author             = { "陈蕃坊" => "493336001@qq.com" }
    s.social_media_url   = "http://www.jianshu.com/users/80fadb71940d/latest_articles"
    s.source       = { :git => "https://github.com/ios002uuu/FAAvoidCrash", :tag => s.version.to_s }
    s.swift_versions = ['5.0']
    s.source_files  = 'AvoidCrash/**/*.{h,m}'

end


