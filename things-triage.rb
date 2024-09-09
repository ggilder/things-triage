#!/usr/bin/env ruby

Dir.chdir(File.dirname(File.realpath(__FILE__)))

require 'rubygems'
require 'bundler'

Bundler.require

require "rb-scpt"
require "action_view"

include ActionView::Helpers::DateHelper

today = Appscript.app("Things3").lists['Today'].to_dos.get.map do |to_do|
  [
    to_do.id_.get,
    to_do.name.get,
    to_do.creation_date.get,
  ]
end

today.sort_by { |to_do| to_do[2] }.each do |to_do|
  puts time_ago_in_words(to_do[2]) + ": #{to_do[1]}"
end
puts "Total: #{today.count}"
