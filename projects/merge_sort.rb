# frozen_string_literal: true

def merge_sort(arr)
  return arr if arr.length <= 1

  mid = arr.length / 2
  left_half = merge_sort(arr[0...mid])
  right_half = merge_sort(arr[mid..-1])

  merge(left_half, right_half)
end

def merge(left, right)
  sorted_array = []

  until left.empty? || right.empty?
    if left.first <= right.first
      sorted_array << left.shift
    else
      sorted_array << right.shift
    end
  end

  sorted_array + left + right
end

p merge_sort([])
p merge_sort([73])
p merge_sort([1, 2, 3, 4, 5])
p merge_sort([3, 2, 1, 13, 8, 5, 0, 1])
p merge_sort([105, 79, 100, 110])