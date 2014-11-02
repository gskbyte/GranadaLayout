Pod::Spec.new do |s|
  s.name         = "GranadaLayout"
  s.version      = "0.2.3"
  s.summary      = "A simple layout system for iOS providing Android-like linear and relative layouts."

  s.description  = <<-DESC
                   GranadaLayout tries to emulate the Android Layout system and bring as much as possible from its functionality to the iOS world.
		   It includes a relative layout to position and size views relative to each other and a linear layout to stack views.
 		   A layout inflater is also provided, so that layouts can be defined in simple JSON files.
                   DESC

  s.homepage     = "https://github.com/gskbyte/GranadaLayout"
  s.license      = "Apache License, Version 2.0"

  s.author       = { "Jose Alcalá Correa" => "jose.alcala.correa@gmail.com" }
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/gskbyte/GranadaLayout.git", :tag => "0.2.3"  }
  s.social_media_url   = "http://twitter.com/gskbyte"
  
  s.requires_arc = "true"
  
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Example/*"
end
