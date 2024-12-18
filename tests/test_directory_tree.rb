require_relative '../lib/directory_tree'
require_relative 'test_helpers'

def test_directory_tree
  test_create
  test_list
  test_delete
  test_move

  given_integration_test
end

def set_up_test_tree
  directory_tree = DirectoryTree.new

  directory_tree.create('a')
  directory_tree.create('a/b')
  directory_tree.create('a/c')
  directory_tree.create('d')
  directory_tree.create('a/c/e')
  directory_tree.create('a/c/f')
  directory_tree.create('d/g')
  directory_tree.create('d/h')

  directory_tree
end

def test_create
  puts 'test_create'
  directory_tree = DirectoryTree.new

  output = capture_io { directory_tree.create('a') }
  assert_equals(output, '')
  output = capture_io { directory_tree.create('a/b/d') }
  assert_equals(output, "Cannot create a/b/d - a/b does not exist\n")
end

def test_list
  puts 'test_list'
  directory_tree = set_up_test_tree

  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
a
  b
  c
    e
    f
d
  g
  h
LIST
  assert_equals(output, expected_list_output)
end

def test_delete
  puts 'test_delete'
  directory_tree = set_up_test_tree

  output = capture_io { directory_tree.delete('a/c/e') }
  assert_equals(output, '')
  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
a
  b
  c
    f
d
  g
  h
LIST

  output = capture_io { directory_tree.delete('a/m/d') }
  assert_equals(output, "Cannot delete a/m/d - a/m does not exist\n")
  output = capture_io { directory_tree.delete('a/b/d') }
  assert_equals(output, "Cannot delete a/b/d - a/b/d does not exist\n")

  output = capture_io { directory_tree.delete('a') }
  assert_equals(output, '')
  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
d
  g
  h
LIST
  assert_equals(output, expected_list_output)
end

def test_move
  puts 'test_move'
  directory_tree = set_up_test_tree

  output = capture_io { directory_tree.move('a/c/e', 'd') }
  assert_equals(output, '')
  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
a
  b
  c
    f
d
  e
  g
  h
LIST
  assert_equals(output, expected_list_output)

  output = capture_io { directory_tree.move('a/m/d', 'd') }
  assert_equals(output, "Cannot move a/m/d - a/m does not exist\n")
  output = capture_io { directory_tree.move('a/b/d', 'd') }
  assert_equals(output, "Cannot move a/b/d - a/b/d does not exist\n")
  output = capture_io { directory_tree.move('a/c/f', 'i') }
  assert_equals(output, "Cannot move a/c/f - i does not exist\n")

  output = capture_io { directory_tree.move('a', 'd') }
  assert_equals(output, '')
  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
d
  a
    b
    c
      f
  e
  g
  h
LIST
  assert_equals(output, expected_list_output)
end

def given_integration_test
  puts 'given_integration_test'
  directory_tree = DirectoryTree.new

  output = capture_io do
    directory_tree.create('fruits')
    directory_tree.create('vegetables')
    directory_tree.create('grains')
    directory_tree.create('fruits/apples')
    directory_tree.create('fruits/apples/fuji')
  end
  assert_equals(output, '')

  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
fruits
  apples
    fuji
grains
vegetables
LIST
  assert_equals(output, expected_list_output)

  output = capture_io do
    directory_tree.create('grains/squash')
    directory_tree.move('grains/squash', 'vegetables')
    directory_tree.create('foods')
    directory_tree.move('grains', 'foods')
    directory_tree.move('fruits', 'foods')
    directory_tree.move('vegetables', 'foods')
  end
  assert_equals(output, '')

  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
foods
  fruits
    apples
      fuji
  grains
  vegetables
    squash
LIST
  assert_equals(output, expected_list_output)

  output = capture_io { directory_tree.delete('fruits/apples') }
  assert_equals(output, "Cannot delete fruits/apples - fruits does not exist\n")

  output = capture_io { directory_tree.delete('foods/fruits/apples') }
  assert_equals(output, '')

  output = capture_io { directory_tree.list }
  expected_list_output = <<~LIST
foods
  fruits
  grains
  vegetables
    squash
LIST
  assert_equals(output, expected_list_output)
end

test_directory_tree
