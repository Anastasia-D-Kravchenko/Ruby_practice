# frozen_string_literal: true

def stock_picker(prices)
  best_profit = 0
  best_days = [0, 0]
  prices.each_with_index do |buy_price, buy_day|
    prices.each_with_index do |sell_price, sell_day|
      if sell_day > buy_day
        profit = sell_price - buy_price
        if profit > best_profit
          best_profit = profit
          best_days = [buy_day, sell_day]
        end
      end

    end
  end
  best_days
end

p stock_picker([17,3,6,9,15,8,6,1,10])
# Expected output: [1,4] (Buy at $3, sell at $15)

p stock_picker([20,3,6,9,15,8,6,1,10])
# Expected output: [1,4]

p stock_picker([17,3,6,9,15,8,6,10,1])
# Expected output: [1,4]


def stock_picker(prices)
  prices.each_with_index.to_a.combination(2).max_by { |buy, sell| sell[0] - buy[0] }.map { |day| day[1] }
end

p stock_picker([17,3,6,9,15,8,6,1,10])
# Expected output: [1,4] (Buy at $3, sell at $15)

p stock_picker([20,3,6,9,15,8,6,1,10])
# Expected output: [1,4]

p stock_picker([17,3,6,9,15,8,6,10,1])
# Expected output: [1,4]