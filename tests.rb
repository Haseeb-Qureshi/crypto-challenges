SLOW_TESTS = [4]

def test_if_defined(i)
  test_output(i) if eval("defined?(challenge_#{i})")
end

def test_output(i)
  output = colorize_output(send("challenge_#{i}"))
  puts "Challenge #{i}: #{output}"
end

def colorize_output(passed)
  passed ? "PASS".green : "FAIL".red
end

def run_tests(n)
  (1..n).each { |num| test_if_defined(num) unless SLOW_TESTS.include?(num) }
end
