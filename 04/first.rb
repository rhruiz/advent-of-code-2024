grid = {}
word = "XMAS".chars
candidates = []
neighbors = [
  [1, 0],
  [1, 1],
  [0, 1],
  [-1, 1],
  [-1, 0],
  [-1, -1],
  [0, -1],
  [1, -1]
]

$stdin.each_line.with_index do |line, y|
  line.chars.each.with_index do |char, x|
    candidates << [x, y] if char == "X"
    grid[[x, y]] = char
  end
end

def delta(x2, y2, x1, y1)
  [x2 - x1, y2 - y1]
end

def mul(delta, n)
  [delta[0] * n, delta[1] * n]
end

def apply(x, y, delta)
  [x + delta[0], y + delta[1]]
end

def test(grid, x, y, delta, word)
  word.each_with_index.all? do |char, i|
    (xn, yn) = apply(x, y, mul(delta, i))
    grid[[xn, yn]] == char
  end
end

candidates
  .map { |(x, y)| neighbors.count { |delta| test(grid, x, y, delta, word) } }
  .sum
  .tap { |result| puts result }
