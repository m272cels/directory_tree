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

  def create(name_or_subdirectory)
    if name_or_subdirectory.respond_to?(:subdirectories)
      subdirectories[name_or_subdirectory.name] = name_or_subdirectory
    else
      subdirectories[name_or_subdirectory] = Directory.new(name_or_subdirectory)
    end
  end

  def delete(name)
    subdirectories.delete(name)
  end

  def find(name)
    subdirectories[name]
  end
end
