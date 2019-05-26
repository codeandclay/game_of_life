# frozen_string_literal: true

require 'rake/testtask'

task default: %w[test]

# task :test do
#   ruby "test/game_of_life_test.rb"
# end

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
