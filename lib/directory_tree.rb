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
    create_target = path.pop

    parent_directory = find(path)
    if parent_directory.nil?
      puts "Cannot create #{name} - #{path.join('/')} does not exist"
      return
    end
    parent_directory.create(create_target)
  end

  def delete(name)
    path = path(name)
    delete_target = path.pop

    parent_directory = find(path)
    if parent_directory.nil?
      puts "Cannot delete #{name} - #{path.join('/')} does not exist"
      return
    end
    if parent_directory.find(delete_target).nil?
      puts "Cannot delete #{name} - #{name} does not exist"
      return
    end
    parent_directory.delete(name)
  end

  def move(name, destination)
    path = path(name)
    move_target = path.pop

    parent_directory = find(path)
    if parent_directory.nil?
      puts "Cannot move #{name} - #{path.join('/')} does not exist"
      return
    end
    if parent_directory.find(move_target).nil?
      puts "Cannot move #{name} - #{name} does not exist"
      return
    end

    destination_path = path(destination)
    destination_directory = find(destination_path)
    if destination_directory.nil?
      puts "Cannot move #{name} - #{destination} does not exist"
      return
    end

    target_directory = parent_directory.delete(move_target)
    destination_directory.create(target_directory)
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
