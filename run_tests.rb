#!/usr/bin/env ruby

require 'colorize'

Dir["set*/*.rb"].sort.each do |file|
  require_relative file
  if test
    puts "#{file} succeeded!".green
  else
    puts "#{file} failed...".red
  end
end
