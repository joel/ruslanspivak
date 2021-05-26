# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Interpreter do # rubocop:disable Metrics/BlockLength
    describe "#ruslanspivak" do # rubocop:disable Metrics/BlockLength
      context "Example 1" do
        let(:input)  { "3+1" }
        let(:result) { 4 }

        subject do
          described_class.new(input)
        end
        it do
          interpreter = subject

          expect(interpreter.next_token).to eql(Token.new(Token::INTEGER, 3))
          expect(interpreter.next_token).to eql(Token.new(Token::PLUS, "+"))
          expect(interpreter.next_token).to eql(Token.new(Token::INTEGER, 1))
          expect(interpreter.next_token).to eql(Token.new(Token::EOF, nil))
          expect(interpreter.next_token).to eql(Token.new(Token::EOF, nil))
        end

        it do
          interpreter = subject

          expect(interpreter.eval_expression).to eql(4)
        end

        it do
          interpreter = subject

          interpreter.instance_variable_set(:@current_token, interpreter.next_token)

          expect do
            interpreter.eat(Token::PLUS)
          end.to raise_error("Parsing error")
        end
      end
    end
  end
end
