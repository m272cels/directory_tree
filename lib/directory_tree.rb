require_relative 'directory'

class DirectoryTree

  attr_reader :root

  def initialize
    @root = Directory.new('root')
  end

  def list
    root.subdirectories.each_value { |subdirectory| subdirectory.list }
  end

  def create(name)
    path = path(name)
    new_directory = path.pop

    parent_directory = find(path)
    if parent_directory.nil?
      puts "Cannot create #{name} - #{path.join('/')} does not exist"
      return
    end
    parent_directory.create(new_directory)
  end

  private

  def find(path)
    current_directory = root
    path.each do |part|
      current_directory = current_directory.find(part)
      return if current_directory.nil?
    end
    current_directory
  end

  def path(name)
    name.split('/')
  end

end
