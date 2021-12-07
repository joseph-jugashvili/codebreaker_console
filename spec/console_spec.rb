# frozen_string_literal: true

require_relative 'spec_helper'

RSpec.describe Console do
  subject(:view_module) { ConsoleGame::View }

  let(:game) { described_class.new }
  let(:name) { 'name' }
  let(:wrong_name) { 'bo' }
  let(:difficulty) { 'hell' }
  let(:wrong_difficulty) { 'hard' }

  describe '#run' do
    after do
      game.run
    rescue SystemExit
      # Ignored
    end

    context 'when user entered rules return rules' do
      before { allow(view_module).to receive(:fetch_user_input).and_return('rules', 'exit') }

      it { expect(view_module).to receive(:rules) }
    end

    context 'when user enteres statistics return stats' do
      before { allow(view_module).to receive(:fetch_user_input).and_return('statistics', 'exit') }

      it { expect(view_module).to receive(:statistics) }
    end

    context 'when user entered exit leave app' do
      before { allow(view_module).to receive(:fetch_user_input).and_return('exit') }

      it { expect { game.run }.to raise_error(SystemExit) }
    end

    context 'when user entered wrong command return error' do
      before do
        allow(view_module).to receive(:fetch_user_input).and_return('aawds', 'exit')
        allow(view_module).to receive(:menu)
      end

      it { expect(view_module).to receive(:menu_message_error) }
    end

    context 'when user finished game' do
      before do
        allow(view_module).to receive(:obtain_guess).and_return('1234')
        allow(view_module).to receive(:fetch_user_input).and_return('start', 'exit')
        allow(view_module).to receive(:obtain_name).and_return(name)
        allow(view_module).to receive(:obtain_difficulty).and_return(difficulty)
        allow(view_module).to receive(:guess_input_error)
        allow(view_module).to receive(:matrix)
        allow(view_module).to receive(:obtain_new_game).and_return('n')
      end

      context 'when user win return win message' do
        before do
          allow(view_module).to receive(:obtain_save).and_return('n')
          allow(view_module).to receive(:obtain_guess).and_return('1111')
          allow_any_instance_of(Codebraker::Game).to receive(:win?).and_return(true, false)
        end

        it { expect(view_module).to receive(:win) }
      end

      context 'when user lose return lose message' do
        before { allow_any_instance_of(Codebraker::Game).to receive(:lose?).and_return(true, false) }

        it { expect(view_module).to receive(:loss) }
      end
    end

    context 'when error' do
      before { allow(view_module).to receive(:fetch_user_input).and_return('start', 'exit') }

      context 'when guess is not correct output error message from view' do
        before do
          allow(view_module).to receive(:obtain_name).and_return(name)
          allow(view_module).to receive(:obtain_difficulty).and_return(difficulty)
          allow(view_module).to receive(:guess_input_error)
          allow(view_module).to receive(:obtain_guess).and_return('654123', 'exit')
        end

        it { expect(view_module).to receive(:guess_input_error) }
      end

      context 'when incorrect register data inputted' do
        context 'when name is incorrect output message' do
          before do
            allow(view_module).to receive(:obtain_name).and_return(wrong_name, name)
            allow(view_module).to receive(:obtain_difficulty).and_return(difficulty)
          end

          it { expect(view_module).to receive(:name_length_error) }
        end

        context 'when difficulty is incorrect output message' do
          before do
            allow(view_module).to receive(:obtain_name).and_return(name)
            allow(view_module).to receive(:obtain_difficulty).and_return(wrong_difficulty, difficulty)
          end

          it { expect(view_module).to receive(:difficulty_input_error) }
        end
      end
    end

    context 'when hint' do
      before do
        allow(view_module).to receive(:fetch_user_input).and_return('start', 'exit')
        allow(view_module).to receive(:obtain_name).and_return(name)
        allow(view_module).to receive(:obtain_difficulty).and_return(difficulty)
      end

      context 'when user enter hint output hint from view' do
        before { allow(view_module).to receive(:obtain_guess).and_return('hint', 'exit') }

        it { expect(view_module).to receive(:hint) }
      end

      context 'when hints is used output appropriate message from view' do
        before { allow(view_module).to receive(:obtain_guess).and_return('hint', 'hint', 'exit') }

        it { expect(view_module).to receive(:no_hints) }
      end
    end
  end
end
