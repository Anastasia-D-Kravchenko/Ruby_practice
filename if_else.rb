grade = 'F'

did_i_pass = case grade #=> create a variable `did_i_pass` and assign the result of a call to case with the variable grade passed in
             when 'A' then "Hell yeah!"
             when 'D' then "Don't tell your mother."
             else "'YOU SHALL NOT PASS!' -Gandalf"
             end

puts did_i_pass

grade = 'F'

case grade
when 'A'
  puts "You're a genius"
  future_bank_account_balance = 5_000_000
when 'D'
  puts "Better luck next time"
  can_i_retire_soon = false
else
  puts "'YOU SHALL NOT PASS!' -Gandalf"
  fml = true
end

if future_bank_account_balance.nil?
  puts ""
elsif future_bank_account_balance < 5_000_000
  puts "You will be homeless"
elsif future_bank_account_balance >= 5_000_000
  puts "Give me ur monay pls XXXXXXXXXXXXX"
end

age = 19
unless age < 18
  puts "Get a job."
end

