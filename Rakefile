desc "Bootstraps the repo"
task :bootstrap do
  sh 'bundle'
  sh 'cd Example && bundle exec pod install'
end

desc "Runs the specs [EMPTY]"
task :spec do
  sh 'xcodebuild -workspace GranadaLayout.xcworkspace -derivedDataPath "./build" -scheme \'Example\' -configuration Debug -destination platform=\'iOS Simulator\',OS=9.2,name=\'iPhone Retina (4-inch)\' clean build test -sdk iphonesimulator GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES GCC_GENERATE_TEST_COVERAGE_FILES=YES | xcpretty -sc && exit ${PIPESTATUS[0]}'
end
