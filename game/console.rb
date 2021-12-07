# frozen_string_literal: true

require_relative 'loader'
require 'pry'

class Console
  include ConsoleGame
  WIN_MATRIX = '++++'

  def run
    loop do
      View.menu
      case View.fetch_user_input
      when I18n.t('menu.start') then start
      when I18n.t('menu.rules') then View.rules
      when I18n.t('menu.statistics') then View.statistics
      when I18n.t('menu.exit') then exit
      else View.menu_message_error end
    end
  end

  def start
    @codebraker_game = ::Codebraker::Game.new
    registration
    @codebraker_game.start
    game
  end

  def registration
    name_input
    input_difficulty
  end

  def name_input
    loop do
      name = View.obtain_name
      begin
        @codebraker_game.user.name = name
        break
      rescue LengthError
        View.name_length_error
      end
    end
  end

  def input_difficulty
    loop do
      difficulty = View.obtain_difficulty
      if difficulty_accessible?(difficulty)
        @codebraker_game.difficulty = difficulty.to_sym
        break
      else
        # binding.pry
        View.difficulty_input_error
      end
    end
  end

  def game
    loop { break if lost? || procced? }
    new_game
  end

  def procced?
    case guess = View.obtain_guess
    when I18n.t('menu.exit') then exit
    when I18n.t('game.hint')
      hint
      false
    else guess_passed?(guess) end
  end

  def lost?
    return unless @codebraker_game.lose?

    View.loss(@codebraker_game.code)
    true
  end

  def hint
    @codebraker_game.check_for_hints? ? View.hint(@codebraker_game.use_hint) : View.no_hints
  end

  def guess_passed?(guess)
    matrix = @codebraker_game.generate_signs(guess)
    @codebraker_game.win?(guess) ? win_screenplay : View.matrix(matrix)
  rescue InputError
    View.guess_input_error
    false
  end

  def win_screenplay
    View.win
    @codebraker_game.save_game(@codebraker_game) if View.obtain_save == I18n.t('menu.agree')
  end

  def new_game
    start if View.obtain_new_game == I18n.t('menu.agree')
  end

  def difficulty_accessible?(difficulty)
    @codebraker_game.check_for_difficulties.keys.map(&:to_s).include?(difficulty)
  end
end
