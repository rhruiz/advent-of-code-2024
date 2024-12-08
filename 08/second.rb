require 'set' unless defined?(Set)
grid = {}
antennas = {}
xmax = 0
ymax = 0

antinodes = Set.new

$stdin.each_line.each_with_index do |line, y|
  ymax = [ymax, y].max
  line.strip.each_char.each_with_index do |chr, x|
    xmax = [xmax, x].max
    grid[[x, y]] = chr
    if chr != '.'
      antennas[chr] ||= []
      antennas[chr] << [x, y]
    end
  end
end

in_bounds = ->((x, y)) { x >= 0 && y >= 0 && x <= xmax && y <= ymax }

antennas.each do |_, coords|
  coords.combination(2).each do |a, b|
    if a[0] == b[0]
      puts "vertical"
      0..ymax.each do |y|
        antinodes << [a[0], y]
      end

      next
    end

    if a[1] == b[1]
      puts "horizontal"
      0..xmax.each do |x|
        antinodes << [x, a[1]]
      end

      next
    end

    dx = b[0] - a[0]
    dy = b[1] - a[1]

    (x, y) = a

    loop do
      break unless in_bounds[[x, y]]
      antinodes << [x, y]

      (x, y) = [x + dx, y + dy]
    end

    (x, y) = b

    loop do
      break unless in_bounds[[x, y]]
      antinodes << [x, y]

      (x, y) = [x - dx, y - dy]
    end
  end
end


if ENV['DEBUG']
  (0..ymax).each do |y|
    (0..xmax).each do |x|
      print antinodes.include?([x, y]) ? '#' : grid[[x, y]]
    end
    puts
  end
end

puts antinodes.size
