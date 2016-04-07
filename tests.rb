SLOW_TESTS = [4]
def test_output(i)
  output = colorize_output(send("challenge_#{i}"))
  puts "Challenge #{i}: #{output}"
end

def colorize_output(passed)
  passed ? "PASS".green : "FAIL".red
end

def run_tests(n)
  (1..n).each { |num| test_output(num) unless SLOW_TESTS.include?(num) }
end
