require_relative 'loader'

module ConsoleGame
  module View
    class << self
      def menu
        puts I18n.t 'menu.info'
      end

      def rules
        puts I18n.t 'game.rules'
      end

      def statistics
        puts Terminal::Table.new(
          headings: ['Name', 'Difficulty', 'Attempts Total', 'Hints Total', 'Attempts Used', 'Hints Used'],
          rows: Codebraker::Statistics.new.show.map(&:values)
        )
      end

      def menu_message_error
        puts I18n.t 'error.command_error'
      end

      def guess_input_error
        puts I18n.t 'error.guess_input_error'
      end

      def name_length_error
        puts I18n.t 'error.name_length_error'
      end

      def difficulty_input_error
        puts I18n.t 'error.difficulty_input_error'
      end

      def win
        puts I18n.t 'game.win'
      end

      def loss(code)
        puts I18n.t('game.loss', code: code)
      end

      def hint(hint)
        puts hint.to_s
      end

      def no_hints
        puts I18n.t 'game.no_hints'
      end

      def matrix(matrix)
        puts I18n.t('game.matrix', matrix: matrix)
      end

      def obtain_name
        fetch_user_input(I18n.t('registration.name'))
      end

      def obtain_guess
        fetch_user_input(I18n.t('game.guess'))
      end

      def obtain_difficulty
        fetch_user_input(I18n.t('game.difficulty'))
      end

      def obtain_save
        fetch_user_input(I18n.t('game.save_result'))
      end

      def obtain_new_game
        fetch_user_input(I18n.t('game.new_game'))
      end

      def fetch_user_input(question = nil)
        puts question if question
        gets.chomp
      end
    end
  end
end
