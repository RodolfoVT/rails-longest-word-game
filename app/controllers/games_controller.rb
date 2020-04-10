require 'open-uri'

class GamesController < ApplicationController

  VOWELS = %w(A E I O U Y)

  def new
    #generate the 10 letters
    vowels = VOWELS.sample(5)
    consonants = (('A'..'Z').to_a - vowels).sample(5)
    @letters = (vowels + consonants).shuffle
  end

  def score
    #get the word, get the letters
    @word = params[:word].upcase
    letters = params[:letters].split
    #validate if the word is part of the letters
    @valid_word = valid_word?(@word, letters)
    #validate if the word is an English word
    @english_word = english_word?(@word)
  end

  private

    def valid_word?(word, letters)
      word.chars.all?{|letter| word.count(letter) <= letters.count(letter)}
    end

    def english_word?(word)
      request = open("https://wagon-dictionary.herokuapp.com/#{word}")
      response = JSON.parse(request.read)
      response["found"]
    end

end
