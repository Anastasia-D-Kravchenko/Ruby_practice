y_true = [1, 1, 0, 0, 1, 0]
y_pred = [1, 0, 1, 0, 1, 1]

tp = 0; tn = 0; fp = 0; fn = 0
y_true.each_with_index do |target, i|
  prediction = y_pred[i]
  if target == 1 && prediction == 1
    tp += 1
  elsif target == 0 && prediction == 0
    tn += 1
  elsif target == 0 && prediction == 1
    fp += 1
  elsif target == 1 && prediction == 0
    fn += 1
  end
end

accuracy = (tp + tn).to_f / y_true.size
p = tp.to_f / (tp + fp)
r = tp.to_f / (tp + fn)
f1 = 2 * (p * r) / (p + r)

puts "Accuracy:  #{(accuracy * 100).round(2)}%"
puts "P:         #{p.round(4)}"
puts "R:         #{r.round(4)}"
puts "F1-Score:  #{f1.round(4)}"