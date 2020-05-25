require 'open-uri'
require 'json'

class GamesController < ApplicationController

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

  def score
    @letter_str = params[:letters]
    @answer = params[:answer]
    @result = is_english_word?(@answer)
    if included?(@answer.upcase, @letter_str)
      if @result == true
        @output = "Congratulations! #{@answer} is a valid English word."
      else
        @output = "Sorry but #{@answer} dose not seen to be a valid English word. "
      end
    else
      @output = "Sorry but #{@answer} can't be built out of #{@letter_str} "
    end
    return @output
  end

end
