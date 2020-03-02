Pod::Spec.new do |spec|
spec.name         = "DiveKit"
spec.version      = "0.9.1"
spec.summary      = "A framework to perform various scuba diving calculations."
spec.description  = <<-DESC
A framework to perform various scuba diving calculations, written in Swift.
DESC
spec.homepage     = "https://github.com/jaytrisw/DiveKit"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author             = { "author" => "joshuatw@gmail.com" }
spec.documentation_url = "https://jaytrisw.github.io/DiveKit"
spec.platforms = { :ios => "11.0", :osx => "10.13", :watchos => "4.0", :tvos => "10.0" }
spec.swift_version = "5.1"
spec.source       = { :git => "https://github.com/jaytrisw/DiveKit.git", :tag => "#{spec.version}" }
spec.source_files  = "Sources/DiveKit/**/*.swift"
end
