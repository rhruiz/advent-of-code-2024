class Item
  attr_accessor :value, :next

  def initialize(value)
    self.value = value
  end
end

input = $stdin.read.strip.split(" ").map(&:to_i)

head = Item.new(input.shift)

input.reduce(head) do |tail, item|
  tail.next = Item.new(item)
end

def print_list(head)
  return unless ENV["DEBUG"]

  loop do
    break if head.nil?

    print head.value
    print " "

    head = head.next
  end

  puts
end

def list_len(head)
  len = 0

  loop do
    break if head.nil?

    len += 1
    head = head.next
  end

  len
end

def blink!(head)
  item = head
  loop do
    break if item.nil?

    if (as_str = item.value.to_s).length.even?
      left = as_str[0..(as_str.length / 2 - 1)].to_i
      right = as_str[(as_str.length / 2)..-1].to_i

      item.value = left
      new_item = Item.new(right)
      new_item.next = item.next
      item.next = new_item
      item = new_item.next
    else
      if item.value == 0
        item.value = 1
      else
        item.value *= 2024
      end

      item = item.next
    end
  end

  head
end

(0...25).each do
  blink!(head)
end

puts list_len(head)
