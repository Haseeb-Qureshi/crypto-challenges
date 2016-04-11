require_relative './bases/bases'
require_relative 'tests'
require 'colorize'
require 'set'

SETS = 2
CHALLENGES = 9
(1..SETS).each do |set|
  (1..CHALLENGES).each do |challenge|
    file = File.join("set#{set}", "c#{challenge}.rb")
    require_relative file if File.exist?(file)
  end
end
run_tests(CHALLENGES)
