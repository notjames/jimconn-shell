HEX_HASH = \
  {
    10 => "A",
    11 => "B",
    12 => "C",
    13 => "D",
    14 => "E",
    15 => "F",
  }

def divide(numerator)
  numerator = numerator.to_i64

  [(numerator / 16).to_i, numerator % 16]
end

def main(value)
  begin
    value.to_i
  rescue Exception
    puts "The input supplied is an invalid value, not a number: %s" % [value.inspect]
    return 1
  end

  result     = [] of Int64 | Int32 | String
  remainders = [] of Int64 | Int32
  value      = value.to_i

  # divide value by 16
  # if answer can still be divided by 16
  # continue to divide answer by 16 until not possible
  # take remainders of each operation from end to beginning
  # convert each to HEX value if 10-15, join for answer

  if (value / 16).to_i == 0
    next_num, remainder = divide(value)
    remainders << remainder
  else
    while (value / 16).to_i != 0
      next_num, remainder = divide(value)
      remainders << remainder

      value = next_num
    end

    remainders << value
  end

  remainders.reverse.each do \
  |v|
    if HEX_HASH.has_key? v.to_i
      v = HEX_HASH[v].to_s
    end
    result << v
  end

  puts result.join("").to_s
  return 0
end

if ARGV[0].nil?
  STDERR.puts "Usage: $0 <decimal value>"
  exit 1
end

exit (main ARGV[0])
