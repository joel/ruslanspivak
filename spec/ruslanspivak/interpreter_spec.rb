# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Interpreter do # rubocop:disable Metrics/BlockLength
    subject do
      described_class.new(input)
    end

    context "with expression" do # rubocop:disable Metrics/BlockLength
      let(:input)  { "3+1" }
      let(:result) { 4 }

      describe "#next_token" do
        it do
          interpreter = subject

          expect(interpreter.next_token).to eql(Token.new(Token::INTEGER, 3))
          expect(interpreter.next_token).to eql(Token.new(Token::PLUS, "+"))
          expect(interpreter.next_token).to eql(Token.new(Token::INTEGER, 1))
          expect(interpreter.next_token).to eql(Token.new(Token::EOF, nil))
          expect(interpreter.next_token).to eql(Token.new(Token::EOF, nil))
        end
      end

      describe "#eval_expression" do
        it do
          interpreter = subject

          expect(interpreter.eval_expression).to eql(4)
        end
      end

      describe "#eat" do
        it do
          interpreter = subject

          interpreter.instance_variable_set(:@current_token, interpreter.next_token)

          expect do
            interpreter.eat(Token::PLUS)
          end.to raise_error("Parsing error")
        end
      end
    end

    context "with expressions" do
      {
        "3+1" => 4,
        "3+5" => 8,
        "2+2" => 4,
        "12+2" => 14,
        "12+22" => 34
      }.each do |expression, result|
        describe "#eval_expression" do
          it do
            interpreter = described_class.new(expression)

            expect(interpreter.eval_expression).to eql(result)
          end
        end
      end
    end
  end
end
