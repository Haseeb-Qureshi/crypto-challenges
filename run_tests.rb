#!/usr/bin/env ruby

require 'colorize'

SLOW_TESTS = %w(c3 c4 c5)

Dir["set*/*.rb"].sort.each do |file|
  next if SLOW_TESTS.any? { |slow_test| file.match(slow_test) }

  require_relative file
  if test
    puts "#{file} succeeded!".green
  else
    puts "#{file} failed...".red
  end
end
