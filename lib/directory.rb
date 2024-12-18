class Directory

  attr_reader :name, :subdirectories

  def initialize(name)
    @name = name
    @subdirectories = {}
  end

  def list(indent = 0)
    puts '  ' * indent + name
    subdirectories.each_value { |subdirectory| subdirectory.list(indent + 1) }
  end

  def create(name)
    subdirectories[name] = Directory.new(name)
  end

  def delete(name)
    subdirectories.delete(name)
  end

  def find(name)
    subdirectories[name]
  end
end
