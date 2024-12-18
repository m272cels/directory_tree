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
