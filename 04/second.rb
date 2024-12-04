grid = {}
candidates = []
NEIGHBORS = [
  [1, 1],
  [-1, -1],
  [-1, 1],
  [1, -1]
]
WIN = [
  %w(M S M S),
  %w(M S S M),
  %w(S M S M),
  %w(S M M S),
]

$stdin.each_line.with_index do |line, y|
  line.chars.each.with_index do |char, x|
    candidates << [x, y] if char == "A"
    grid[[x, y]] = char
  end
end

def apply(x, y, delta)
  [x + delta[0], y + delta[1]]
end

def test(grid, x, y)
  WIN.member?(NEIGHBORS.map { |delta| grid[apply(x, y, delta)] })
end

candidates
  .select { |(x, y)| test(grid, x, y) }
  .count
  .tap { |result| puts result }
