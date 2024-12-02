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

puts($stdin.each_line.count do |line|
  levels = line.strip.split(/ +/).map(&:to_i)
  safe?(levels)
end)
