#!/usr/bin/env ruby

Dir.chdir(File.dirname(File.realpath(__FILE__)))

require 'rubygems'
require 'bundler'

Bundler.require

require "rb-scpt"
require "action_view"

include ActionView::Helpers::DateHelper

class TodoList
  def initialize(list)
    @list = list
    @todos = []
    @app = Appscript.app("Things3")
    refresh
  end

  def refresh
    @todos = @app.lists[@list].to_dos.get.sort_by { |to_do| to_do.creation_date.get }
  end

  def display
    @todos.each_with_index do |to_do, index|
      puts "#{index + 1}. " + time_ago_in_words(to_do.creation_date.get) + ": #{to_do.name.get}"
    end
    puts "Total: #{@todos.count}"
  end

  def show(index)
    @todos[index].show
    @app.activate
  end

  def count
    @todos.count
  end
end


today = TodoList.new('Today')
today.display

while true do
  puts "Select a task to show, [r]efresh, or [q]uit"
  print "> "
  selected = gets
  case selected.to_s.chomp
  when /\d+/
    selected = selected.to_i
    if selected > 0 && selected <= today.count
      today.show(selected - 1)
    end
  when /[rR]/
    today.refresh
    today.display
  when /[qQ]/
    break
  end
end
