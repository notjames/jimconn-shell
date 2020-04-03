def fib(n)
  return 0 if n == 0

  last    = 0u128
  current = 1u128

  puts "n: %s\tlast: %s\tcurrent: %s" % [typeof(n), typeof(last), typeof(current)]
  (n - 1).times do
    last, current = current, last + current
  end

  current
end

def usage
  progname = String.new(ARGV_UNSAFE.value)

  STDERR.puts <<-H
  #{progname} <integer>
    Given Fibonacci; determine which fib value would
    exist at <integer> index.
  H

  exit 1
end

if ARGV.empty?
  usage
end

begin
  i = ARGV[0].to_i64
  puts fib i
rescue e
  STDERR.puts e
  usage
end
