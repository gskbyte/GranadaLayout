Pod::Spec.new do |s|
  s.name         = "GranadaLayout"
  s.version      = "0.0.1"
  s.summary      = "A simple but powerful and efficient layout system for iOS."

  s.description  = <<-DESC
                   GranadaLayout tries to emulate the Android Layout system and bring as much as possible from its functionality to the iOS world.
                   DESC

  s.homepage     = "https://github.com/gskbyte/GranadaLayout"
  s.license      = "Apache License, Version 2.0"

  s.author             = { "Jose Alcalá Correa" => "jose.alcala.correa@gmail.com" }
  s.platform     = :ios, "6.0"


  s.source       = { :git => "https://github.com/gskbyte/GranadaLayout.git" }
  #s.source       = { :git => "https://github.com/gskbyte/GranadaLayout.git", :tag => "0.0.1" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Example/*"
end
