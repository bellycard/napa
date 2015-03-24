#!/usr/local/bin/ruby

require 'yaml'

# attempt to parse Procfile
begin
  proc = YAML.load_file('Procfile')
  command = proc[ARGV[0]]

  if command
    exec(command)
  else
    puts "Could not find #{ARGV[0]} in Procfile"
    exit 1
  end
rescue
  puts 'Failed to parse Procfile'
  exit 2
end
