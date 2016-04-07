require_relative './bases/bases'
require_relative 'tests'
require 'colorize'
require 'set'

SETS = 1
CHALLENGES = 5
(1..SETS).each do |set|
  (1..CHALLENGES).each do |challenge|
    require_relative File.join("set#{set}", "c#{challenge}")
  end
  run_tests(CHALLENGES)
end
