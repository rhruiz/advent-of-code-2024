require 'set' unless defined?(Set)

reading_rules = true
before = {}
after = {}
updates = []

$stdin.each_line do |line|
  line = line.strip

  if line == ""
    reading_rules = false
    next
  end

  if reading_rules
    (left, right) = line.split("|")

    before[right] ||= Set.new
    after[left] ||= Set.new

    before[right].add(left)
    after[left].add(right)
  else
    updates << line.split(",")
  end
end

incorrect = updates.reject do |update|
  update.each_with_index.all? do |page, index|
    (after[page].nil? || update[0...index].all? do |prev|
      !after[page].member?(prev)
    end) && (before[page].nil? || update[(index + 1)..-1].all? do |nxt|
      !before[page].member?(nxt)
    end)
  end
end
