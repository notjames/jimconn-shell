# what would the fibonacci number be at index P?
# fib: 0 1 1 2 3 5 8 13 21 34 55 89
# idx: 0 1 2 3 4 5 6 7  8  9  10 11
#
# given p == 7; return 13
#

# 0 : last=0  now=1
# 1 : last=1  now=2
# 2 : last=2  now=3
# 3 : last=3  now=5
# 4 : last=5  now=8
# 5 : last=8  now=13
# 6 : last=13 now=21

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

#def f(p)
#  fib_now   = 0u64
#  fib_last  = 0u64
#  fib_hold  = 0u64
#  i         = 0u64
#
#  return 0 if p == 0
#
#  puts "p: %s\tfib_now: %s\tfib_last: %s\tfib_hold: %s\ti: %s" % [typeof(p), typeof(fib_now), typeof(fib_last), typeof(fib_hold), typeof(i)]
#  loop do
#    if fib_now == 0
#      fib_last = 0u64
#      fib_now  = 1u64
#      i += 1u64
#      next
#    end
#
#    fib_hold = fib_now
#
#    fib_now  = fib_last + fib_now
#    fib_last = fib_hold
#
#    #puts "fib_last is: %s\tfib_now is: %s" % [fib_last, fib_now]
#    puts "p: %s\tfib_now: %s\tfib_last: %s\tfib_hold: %s\ti: %s" % [typeof(p), typeof(fib_now), typeof(fib_last), typeof(fib_hold), typeof(i)]
#
#    return fib_now if i == p
#
#    i += 1
#  end
#end

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
