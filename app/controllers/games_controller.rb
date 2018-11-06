require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    # byebug
    @word = { value: params[:your_word].upcase }
    @start_letters = hashify(params[:letters].split(" "))
    @answer_letters = hashify(@word[:value].split(''))
    @word[:english_word] = english_word?(@word[:value])
    byebug
    @word[:matching] = matching?(@answer_letters, @start_letters)
    if @word[:matching] == false
      @message = "#{@word[:value]} is not matching with the grid #{params[:letters]}"
    elsif @word[:english_word] == false
      @message = "#{@word[:value]} is not an english word"
    else
      user_points = points(@word[:value])
      @message = "Congratulations! your score is #{user_points} with #{@word[:value]}."
    end
  end

  private

  def points(word)
    word.length**2
  end

  def hashify(letters)
    result = Hash.new(0)
    letters.each do |letter|
      result[letter.to_sym] += 1
    end
    result
  end

  def matching?(letters_h1, letters_h2)
    letters_h1.each do |key, value|
      return false if value > letters_h2[key]
    end
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    result = JSON.parse(word_serialized)
    result['found']
  end
end
