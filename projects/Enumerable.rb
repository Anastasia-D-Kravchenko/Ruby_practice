# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    array = self.to_a
    i = 0
    while i < array.length
      yield(array[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    array = self.to_a
    i = 0
    while i < array.length
      yield(array[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    result = []
    my_each { |item| result << item if yield(item) }
    result
  end

  def my_all?(pattern = nil)
    if block_given?
      my_each { |item| return false unless yield(item) }
    elsif pattern
      my_each { |item| return false unless pattern === item }
    else
      my_each { |item| return false unless item }
    end
    true
  end

  def my_any?(pattern = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
    elsif pattern
      my_each { |item| return true if pattern === item }
    else
      my_each { |item| return true if item }
    end
    false
  end

  def my_none?(pattern = nil)
    if block_given?
      my_each { |item| return false if yield(item) }
    elsif pattern
      my_each { |item| return false if pattern === item }
    else
      my_each { |item| return false if item }
    end
    true
  end

  def my_count(item = nil)
    count = 0
    if block_given?
      my_each { |i| count += 1 if yield(i) }
    elsif !item.nil?
      my_each { |i| count += 1 if i == item }
    else
      return self.size
    end
    count
  end

  def my_map(proc = nil)
    return to_enum(:my_map) if !block_given? && proc.nil?

    result = []
    my_each do |item|
      result << (proc ? proc.call(item) : yield(item))
    end
    result
  end

  def my_inject(initial = nil, sym = nil)
    array = self.to_a

    if block_given?
      memo = initial.nil? ? array[0] : initial
      array = initial.nil? ? array[1..-1] : array
      array.my_each { |item| memo = yield(memo, item) }
      memo
    else
      if sym.nil?
        sym = initial
        memo = array[0]
        array = array[1..-1]
      else
        memo = initial
      end
      array.my_each { |item| memo = memo.send(sym, item) }
      memo
    end
  end
end