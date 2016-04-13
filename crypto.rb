require_relative './bases/bases'
require_relative 'tests'
require 'colorize'
require 'set'

SETS = 2
CHALLENGES = 36
set_no = 1

(1..CHALLENGES).each do |challenge|
  file = File.join("set#{set_no}", "c#{challenge}.rb")

  if File.exist?(file)
    require_relative file
  elsif set_no < SETS
    set_no += 1
    redo
  end
end
run_tests(CHALLENGES)
