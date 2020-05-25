require 'open-uri'
require 'json'

class GamesController < ApplicationController
  # def timestamp

  # end

  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def is_english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def included?(guess, given)
    guess.chars.all? { |letter| guess.count(letter) <= given.count(letter) }
  end

  # def compute_score(attempt, time_taken)
  #   time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  # end

  def score
    @points = 0
    @letter_str = params[:letters]
    @answer = params[:answer]
    @result = is_english_word?(@answer)
    if included?(@answer.upcase, @letter_str)
      if @result == true
        @points += @answer.length
        @output = "Congratulations! #{@answer} is a valid English word. Your got #{@answer.length} points"
      else
        @output = "Sorry but #{@answer} dose not seen to be a valid English word. "
      end
    else
      @output = "Sorry but #{@answer} can't be built out of #{@letter_str} "
    end
    return @output
  end

end
