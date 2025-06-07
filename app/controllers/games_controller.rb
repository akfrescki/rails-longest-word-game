require 'open-uri'

class GamesController < ApplicationController
  # Defines a constant array uppercase vowel letters
  # %w is a shorthand for creating an array of strings
  VOWELS = %w(A E I O U Y)

  def new
    # Generates 10 random uppercase letters
    # 5 vowels
    @letters = Array.new(5) { VOWELS.sample }
    # Adds 5 random consonants to the letters array
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    # we suffle the letters to randomize their order
    @letters.shuffle!
  end

  def score
    # retrieves the letters originally shown on the grid fromm the form
    # .split splits the string into an array of letters
    @letters = params[:letters].split
    # grabs the users typed word
    # if params[:word] is nil, it defaults to an empty string
    @word = (params[:word] || '').upcase
    # calls a private method to check if the word can be formed with the given letters
    @included = included?(@word, @letters)
    # calls a private method to check if the word is an English word
    @english_word = english_word?(@word)
  end

  private

  # Helpers methods used only within this controller
  def included?(word, letters)
    # Check if the word can be formed with the given letters
    # for every letter in the word, it checks if the count of that letter in the word
    # Ex: FOOD and there is only one O in the letters, it will return false
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    # it will open the URL to the dictionary API and parse the JSON response
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    # returns true if the word is found in the dictionary, false otherwise
    json['found']
  end
end
