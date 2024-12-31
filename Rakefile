desc "Setup local dev environment"
task setup: %w[dev:stubs dev:sync]

desc "Run all test suites"
task :test do
  run_tests "wyvernsupport"
  run_tests "wyvernscene"
end

namespace :dev do
  desc "Download/update DragonRuby Yard stubs"
  task :stubs do
    sh "rm -rf .dragon_stubs"
    sh "git clone https://github.com/owenbutler/dragonruby-yard-doc.git .dragon_stubs"
    sh "rm -rf .dragon_stubs/.git"
  end

  desc "Sync WyvernSupport with other libraries for testing"
  task :sync do
    sh "rm -rf wyvernscene/deps"
    sh "mkdir -p wyvernscene/deps"
    sh "cp -R wyvernsupport/lib/* wyvernscene/deps"
  end
end

namespace :test do
  desc "Run WyvernSupport test suite"
  task :support do
    run_tests "wyvernsupport"
  end

  desc "Run WyvernScene test suite"
  task :scene do
    run_tests "wyvernscene"
  end
end

def run_tests(lib)
  sh "mkdir -p tmp"
  sh "./dragonruby #{lib} --eval tests/test.rb --no-tick | tee tmp/#{lib}_tests.log"
  sh "grep '\\[Game\\] 0 test(s) failed.' tmp/#{lib}_tests.log"
end
