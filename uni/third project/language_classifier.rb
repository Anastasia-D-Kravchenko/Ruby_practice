# frozen_string_literal: true
require 'csv'

class Perceptron
  attr_accessor :weights, :threshold, :language

  def initialize(language, input_size = 26, learning_rate = 0.05)
    @language = language
    @weights = Array.new(input_size) { rand(-0.1..0.1) }
    @threshold = rand(-0.1..0.1)
    @learning_rate = learning_rate
  end

  def compute_activation(inputs)
    sum = 0
    inputs.each_with_index { |val, i| sum += val * @weights[i] }
    sum - @threshold
  end

  def train(inputs, target)
    output = compute_activation(inputs)
    error = target - output

    @weights.each_with_index do |w, i|
      @weights[i] += @learning_rate * error * inputs[i]
    end
    @threshold -= @learning_rate * error
  end
end

class LanguageNetwork
  attr_reader :perceptrons, :profiles

  def initialize(languages)
    @perceptrons = languages.map { |lang| Perceptron.new(lang) }
    @profiles = languages.each_with_object({}) { |l, h| h[l] = Array.new(26, 0.0) }
    @profile_counts = Hash.new(0)
  end

  def vectorize(text)
    text = text.downcase
    counts = Array.new(26, 0)

    text.each_char do |char|
      if char.between?('a', 'z')
        index = char.ord - 'a'.ord
        counts[index] += 1
      end
    end

    sum_sq = counts.sum { |count| count**2 }
    magnitude = Math.sqrt(sum_sq)
    return {} if magnitude == 0

    alphabet = ('a'..'z').to_a
    alphabet.each_with_index.each_with_object({}) do |(char, index), hash|
      hash[char] = (counts[index] / magnitude).round(4)
    end
  end

  def train_from_csv(file_name, epochs = 200)
    file_path = File.join(__dir__, file_name)

    epochs.times do
      CSV.foreach(file_path, headers: false) do |row|
        target_lang = row[0]
        text = row[1..-1].join(",")

        vector_map = vectorize(text)
        next if vector_map.empty?
        inputs = vector_map.values

        @profiles[target_lang] = @profiles[target_lang].zip(inputs).map { |a, b| a + b }
        @profile_counts[target_lang] += 1

        @perceptrons.each do |p|
          target = (p.language == target_lang ? 1 : 0)
          p.train(inputs, target)
        end
      end
    end

    @profiles.each do |lang, sums|
      count = @profile_counts[lang]
      @profiles[lang] = sums.map { |v| count > 0 ? (v / count).round(4) : 0 }
    end
  end

  def classify(text)
    classify_detailed(text)[:best]
  end

  def classify_detailed(text)
    vector_map = vectorize(text)
    return { best: "Unknown", scores: {} } if vector_map.empty?

    inputs = vector_map.values
    activations = @perceptrons.map { |p| [p.language, p.compute_activation(inputs)] }.to_h

    max_act = activations.values.max
    exponentials = activations.transform_values { |act| Math.exp(act - max_act) }
    sum_exps = exponentials.values.sum

    scores = exponentials.transform_values { |e| ((e / sum_exps) * 100).round(2) }
    best_lang = scores.max_by { |_, v| v }.first

    { best: best_lang, scores: scores }
  end
end