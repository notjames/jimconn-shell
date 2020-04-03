#!/usr/bin/env ruby
#
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

def f(p)
  fib_now   = 0
  fib_last  = 0
  fib_hold  = 0
  i         = 0

  return 0 if p == 0

  loop do
    if fib_now == 0
      fib_last = 0
      fib_now  = 1
      i += 1
      next
    end

    fib_hold = fib_now

    fib_now  = fib_last + fib_now
    fib_last = fib_hold

    #puts "fib_last is: %s\tfib_now is: %s" % [fib_last, fib_now]

    return fib_now if i == p

    i += 1
  end
end

def usage
  progname = String.new(ARGV_UNSAFE.value)

  $stderr.puts <<-H
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
  puts f ARGV[0].to_i
rescue Exception => e
  $stderr.puts e
  usage
end
