

left = []
right = []

$stdin.each_line do |line|
  (a, b) = line.strip.split(/ +/).map(&:to_i)

  left << a
  right << b
end

puts left.sort.zip(right.sort).map { |(a, b)| (a - b).abs }.sum
