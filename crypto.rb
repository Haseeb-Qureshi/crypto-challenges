require_relative './bases/bases'
require_relative 'tests'
require 'colorize'

sets = 1
challenges = 3
(1..sets).each do |set|
  (1..challenges).each do |challenge|
    require_relative File.join("set#{set}", "c#{challenge}")
  end
end

run_tests(challenges)
