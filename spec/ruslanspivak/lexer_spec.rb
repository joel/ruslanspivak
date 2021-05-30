# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Lexer do
    subject do
      described_class.new(input)
    end

    context "with expression" do
      let(:input) { "30 * 7 / ( 2 + 3 ) - 4" }

      describe "#next_token" do
        it do
          lexer = subject

          expect(lexer.next_token).to eql(Token.new(Token::INTEGER, 30))
          expect(lexer.next_token).to eql(Token.new(Token::MUL, "*"))
          expect(lexer.next_token).to eql(Token.new(Token::INTEGER, 7))
          expect(lexer.next_token).to eql(Token.new(Token::DIV, "/"))
          expect(lexer.next_token).to eql(Token.new(Token::LPAREN, "("))
          expect(lexer.next_token).to eql(Token.new(Token::INTEGER, 2))
          expect(lexer.next_token).to eql(Token.new(Token::PLUS, "+"))
          expect(lexer.next_token).to eql(Token.new(Token::INTEGER, 3))
          expect(lexer.next_token).to eql(Token.new(Token::RPAREN, ")"))
          expect(lexer.next_token).to eql(Token.new(Token::MINUS, "-"))
          expect(lexer.next_token).to eql(Token.new(Token::INTEGER, 4))
        end
      end
    end
  end
end
