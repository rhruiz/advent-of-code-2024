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

antennas.each do |_, coords|
  coords.combination(2).each do |a, b|
    xdistance = a[0] - b[0]
    ydistance = a[1] - b[1]

    an1 = [a[0] + xdistance, a[1] + ydistance]
    an2 = [b[0] - xdistance, b[1] - ydistance]

    antinodes << an1 if an1[0] >= 0 && an1[1] >= 0 && an1[0] <= xmax && an1[1] <= ymax
    antinodes << an2 if an2[0] >= 0 && an2[1] >= 0 && an2[0] <= xmax && an2[1] <= ymax
  end
end


if ENV['DEBUG']
  (0..ymax).each do |y|
    (0..xmax).each do |x|
      print antinodes.include?([x, y]) ? 'X' : grid[[x, y]]
    end
    puts
  end
end

puts antinodes.size
