left = []
right = Hash.new { |_key| 0 }

$stdin.each_line do |line|
  (a, b) = line.strip.split(/ +/).map(&:to_i)

  left << a
  right[b] += 1
end

puts left.reduce(0) { |acc, item| acc + right[item] * item }
