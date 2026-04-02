# frozen_string_literal: true

class HashMap
  LOAD_FACTOR = 0.75

  def initialize
    @capacity = 16
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code
  end

  def set(key, value)
    grow if @size >= @capacity * LOAD_FACTOR

    index = hash(key) % @capacity
    check_bounds(index)

    bucket = @buckets[index]
    pair = bucket.find { |k, v| k == key }

    if pair
      pair[1] = value
    else
      bucket << [key, value]
      @size += 1
    end
  end

  def get(key)
    index = hash(key) % @capacity
    check_bounds(index)

    pair = @buckets[index].find { |k, v| k == key }
    pair ? pair[1] : nil
  end

  def has?(key)
    !get(key).nil?
  end

  def remove(key)
    index = hash(key) % @capacity
    check_bounds(index)

    bucket = @buckets[index]
    pair_index = bucket.index { |k, v| k == key }

    if pair_index
      @size -= 1
      bucket.delete_at(pair_index)[1]
    else
      nil
    end
  end

  def length
    @size
  end

  def clear
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def keys
    entries.map { |pair| pair[0] }
  end

  def values
    entries.map { |pair| pair[1] }
  end

  def entries
    @buckets.flatten(1)
  end

  private

  def check_bounds(index)
    raise IndexError if index.negative? || index >= @buckets.length
  end

  def grow
    old_entries = entries
    @capacity *= 2
    @buckets = Array.new(@capacity) { [] }
    @size = 0

    old_entries.each { |key, value| set(key, value) }
  end
end

class HashSet < HashMap
  def set(key)
    super(key, nil)
  end

  def entries
    keys
  end
end