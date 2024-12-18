require_relative '../lib/directory_tree'

directory_tree = DirectoryTree.new

help_message = <<~HELP

LIST - Lists directories
CREATE <name> - Creates a new directory
HELP - Displays this help message
QUIT or EXIT - Exits

HELP

trap('INT') { puts; exit } # handle Ctrl+C

while true
  print "> "
  input = gets
  break if input.nil? # handle Ctrl+D

  command = input.chomp

  case command
  when 'LIST'
    directory_tree.list
  when /^CREATE (.+)/
    directory_tree.create($1)
  when /^DELETE (.+)/
    directory_tree.delete($1)
  when 'HELP'
    puts help_message
  when 'QUIT', 'EXIT'
    break
  else
    puts "Invalid command: #{command}"
  end

end
