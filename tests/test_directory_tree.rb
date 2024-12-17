require_relative '../lib/directory_tree'
require 'stringio'

def capture_io
  old_stdout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = old_stdout
end

def assert_equals(actual, expected)
  if expected == actual
    puts 'PASS'
  else
    puts "FAIL: #{actual} != #{expected}"
  end
end

def test_directory_tree
  test_create
  test_list
end

def test_create
  directory_tree = DirectoryTree.new

  output = capture_io { directory_tree.create('a') }
  assert_equals(output, '')
  output = capture_io { directory_tree.create('a/b/d') }
  assert_equals(output, "Cannot create a/b/d - a/b does not exist\n")
end

def test_list
  directory_tree = DirectoryTree.new

  directory_tree.create('a')
  output = capture_io { directory_tree.list }
  assert_equals(output, "a\n")
  directory_tree.create('a/b')
  directory_tree.create('c')
  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
a
  b
c
LIST
  assert_equals(output, expected_list_output)
  directory_tree.create('a/b/d')
  directory_tree.create('a/b/e')
  directory_tree.create('c/f')
  directory_tree.create('c/g')
  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
a
  b
    d
    e
c
  f
  g
LIST
  assert_equals(output, expected_list_output)
end

test_directory_tree
