require 'pry-byebug'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = []
    # @score = params[:score]
    @score ||= session[:score]
    @score = 0 if @score.nil?
    # binding.pry
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
    @letters_string = @letters.join(",")
  end

  def score
    @answer_arr = params[:answer].upcase.split('')
    @letters = params[:letters].split(",")
    @score = params[:score].to_i
    @response = ""
    @answer_hash = {}
    @letters_hash = {}

    @answer_arr.each do |letter|
      if @answer_hash[letter].nil?
        @answer_hash[letter] = 1
      else
        @answer_hash[letter] += 1
      end
    end

    @letters.each do |letter|
      if @letters_hash[letter].nil?
        @letters_hash[letter] = 1
      else
        @letters_hash[letter] += 1
      end
    end

    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"
    api_response = open(url).read
    check_word = JSON.parse(api_response)

    @answer_included = @answer_hash.all? do |letter, frequency|
      if @letters_hash[letter].nil?
        false
      else
        @letters_hash[letter] >= frequency
      end
    end
    # binding.pry
    if check_word["found"] == false
      @response = "Sorry but #{@answer_arr.join("")} is not a valid english word..."
    elsif @answer_included == true
      @response = "Congratulations! #{@answer_arr.join("")} is an english word and is part of #{params[:letters]}"
      @score += @answer_arr.length
    else
      @response = "Sorry but #{@answer_arr.join("")} can't be built out of #{params[:letters]}"
    end

    session[:score] = @score
  end
end

# grid = ['a', 'b', 'a'] => { 'a': 2, b: 1}
# attempt = ['a', 'b'] => { 'a': 1, b: 1}

# attempt.all? do |k, v|
#   grid[k] >= attempt[k]
# end
# <%= hidden_field_tag authenticity_token: form_authenticity_token %>
# <%= hidden_field_tag letter: @letters %>

# "Sorry but #{@answer_arr.join("")} can't be built out of #{params[:letters]}"
