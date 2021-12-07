# frozen_string_literal: true

RSpec.shared_examples 'gets chomp' do |name_function, *args|
  describe "##{name_function}" do
    context 'with input request' do
      before do
        allow(subject).to receive(:print)
        allow(subject).to receive(:puts)
      end

      it do
        expect(subject).to receive_message_chain(:gets, :chomp)
        subject.public_send(name_function, *args)
      end
    end
  end
end

RSpec.shared_examples 'puts method' do |name_function, *args|
  describe "##{name_function}" do
    it 'output text' do
      expect(subject).to receive(:puts)
      subject.public_send(name_function, *args)
    end
  end
end

RSpec.describe ConsoleGame::View do
  %i[obtain_guess obtain_name obtain_difficulty obtain_save obtain_new_game].each do |function_name|
    include_examples 'gets chomp', function_name
  end

  %i[menu rules menu_message_error guess_input_error name_length_error difficulty_input_error no_hints
     win].each do |function_name|
    include_examples 'puts method', function_name
  end
  include_examples 'puts method', :statistics
  include_examples 'puts method', :matrix, '+'
  include_examples 'puts method', :hint, '1'
  include_examples 'puts method', :loss, '1111'
end
