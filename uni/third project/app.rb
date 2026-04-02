require 'sinatra'
require 'json'
require 'erb'
require 'open-uri'
require_relative 'language_classifier'

def fetch_internet_dictionary
  dictionaries = { "English" => [], "German" => [], "Polish" => [], "Spanish" => [] }

  repo_base = "https://raw.githubusercontent.com/hermitdave/FrequencyWords/master/content/2016"
  codes = { "English" => "en", "German" => "de", "Polish" => "pl", "Spanish" => "es" }

  puts "Fetching internet dictionaries for EN, DE, PL, ES..."

  codes.each do |lang, code|
    begin
      url = "#{repo_base}/#{code}/#{code}_50k.txt"
      content = URI.open(url).read.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

      valid_short_words = %w[a i w z o y e]
      words_extracted = []

      content.lines.each do |line|
        parts = line.split(' ')
        word = parts[0]
        freq = parts[1].to_i

        if word && (word.length > 1 || valid_short_words.include?(word.downcase))
          words_extracted << { word: word, freq: freq }
        end

        break if words_extracted.size >= 100
      end

      dictionaries[lang] = words_extracted
      puts "Loaded #{lang}"
    rescue => e
      puts "Failed to load #{lang}: #{e.message}"
      dictionaries[lang] = [{word: "error", freq: 1}]
    end
  end

  dictionaries
end

DICTIONARIES = fetch_internet_dictionary

languages = %w[English German Polish Spanish]
network = LanguageNetwork.new(languages)
network.train_from_csv('lang.train.csv')

def evaluate_network(network)
  test_file = File.join(__dir__, 'lang.test.csv')
  correct = 0; total = 0; test_results = []

  CSV.foreach(test_file, headers: false) do |row|
    actual, text = row[0], row[1..-1].join(",")
    detailed = network.classify_detailed(text)
    predicted = detailed[:best]
    is_correct = (predicted == actual)
    correct += 1 if is_correct

    if test_results.size < 100
      test_results << { actual: actual, predicted: predicted, text: text[0..80] + "...", full_text: text, correct: is_correct }
    end
    total += 1
  end
  [(correct.to_f / total * 100).round(2), test_results]
end

accuracy, test_results = evaluate_network(network)

get '/' do
  erb :index, locals: {
    result: nil, text: "", accuracy: accuracy, test_results: test_results,
    network: network, dictionaries: DICTIONARIES, scores: nil
  }
end

post '/classify' do
  text = params[:text_input]
  detailed = network.classify_detailed(text)
  vector_map = network.vectorize(text)

  erb :index, locals: {
    result: detailed[:best], scores: detailed[:scores], text: text,
    accuracy: accuracy, test_results: test_results, network: network,
    vector_map: vector_map, dictionaries: DICTIONARIES
  }
end