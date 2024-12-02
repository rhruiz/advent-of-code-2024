class BadDelta < StandardError; end

def safe?(levels)
  last_delta = nil
  levels.each_cons(2) do |(a, b)|
    return if b.nil?

    delta = (b - a)
    fail BadDelta if delta.abs < 1 or delta.abs > 3 or delta == 0

    if last_delta
      fail BadDelta if last_delta * delta < 0
    end

    last_delta = delta
  end

  true
rescue BadDelta
  false
end

def give_it_chance(levels)
  (0..levels.length).any? do |i|
    safe?(levels.dup.tap { |e| e.delete_at(i) })
  end
end

puts($stdin.each_line.count do |line|
  levels = line.strip.split(/ +/).map(&:to_i)

  if !safe?(levels)
    give_it_chance(levels)
  else
    true
  end
end)
