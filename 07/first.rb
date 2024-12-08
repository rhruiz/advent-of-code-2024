require 'set' unless defined?(Set)

equations = []
results = Set.new

$stdin.each_line do |line|
  (result, line) = line.split(": ")
  equations << [result.to_i, line.strip.split(" ").map(&:to_i)]
end

equations.each do |(result, terms)|
  queue = []
  queue << [result, terms.dup, []]

  loop do
    break if queue.empty?

    (current_result, terms) = queue.pop

    if terms.length == 1
      if terms == [current_result]
        results << result
      end

      next
    end

    term = terms.pop

    if current_result % term != 0
      queue << [current_result - term, terms.dup]
    else
      queue << [current_result / term, terms.dup]
      queue << [current_result - term, terms.dup]
    end
  end
end

puts results.sum
