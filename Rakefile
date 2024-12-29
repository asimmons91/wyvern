desc "Setup local dev environment"
task setup: ["dev:stubs"]

desc "Run all test suites"
task test: ["test:support"]

namespace :dev do
  desc "Download/update DragonRuby Yard stubs"
  task :stubs do
    sh "rm -rf .dragon_stubs"
    sh "git clone https://github.com/owenbutler/dragonruby-yard-doc.git .dragon_stubs"
    sh "rm -rf .dragon_stubs/.git"
  end
end

namespace :test do
  desc "Run WyvernSupport test suite"
  task support: ["test:suite[wyvernsupport]"]

  desc "Run a test suite"
  task :suite, [:suite] do |t, args|
    sh "./dragonruby #{args[:suite]} --eval tests/test.rb --no-tick"
  end

  desc "Run a test suite in a CI friendly manner"
  task :ci, [:suite] do |t, args|
    sh "rm -rf tmp && mkdir tmp"
    sh "./dragonruby #{args[:suite]} --eval tests/test.rb --no-tick | tee tmp/#{args[:suite]}_tests.log"
    sh "grep '[Game] 0 test(s) failed.' tmp/#{args[:suite]}_tests.log"
  end
end
