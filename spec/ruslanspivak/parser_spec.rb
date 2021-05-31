# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Parser do # rubocop:disable Metrics/BlockLength
    context "integration" do
      let(:input)  { "7 + 3 * 4" }
      let(:lexer)  { Lexer.new(input) }

      subject { described_class.new(lexer) }

      describe "#parse" do
        it do
          # BinOp(
          #   Num(Token(INTEGER, 7)),
          #   Token(PLUS, +),
          #   BinOp(
          #     Num(Token(INTEGER, 3)), Token(MUL, *), Num(Token(INTEGER, 4))
          #   )
          # )
          expect(subject.parse.to_s).to eql("BinOp("\
            "Num(Token(INTEGER, 7)), Token(PLUS, +), "\
            "BinOp(Num(Token(INTEGER, 3)), Token(MUL, *), Num(Token(INTEGER, 4))))")
        end
      end
    end

    describe "#factor" do
      let(:token)  { Ruslanspivak::Token.new(Token::INTEGER, 1) }
      let(:lexer)  { instance_double("Ruslanspivak::Lexer", next_token: token) }

      subject { described_class.new(lexer) }

      before do
        expect(subject).to receive(:eat).with(Token::INTEGER)
      end
      it do
        expect(subject.send(:factor)).to eql(Num.new(Token.new(Token::INTEGER, 1)))
      end
    end

    describe "#term" do # rubocop:disable Metrics/BlockLength
      let(:lexer) { instance_double("Ruslanspivak::Lexer") }

      subject { described_class.new(lexer) }

      before do
        allow(lexer).to receive(:next_token).and_return(*tokens)
      end

      context "with only an operand" do
        let(:tokens) do
          [
            Token.new(Token::INTEGER, 2)
          ]
        end

        it "should return the operand" do
          expect(subject.send(:term)).to eql(Num.new(Token.new(Token::INTEGER, 2)))
        end
      end

      context "with operation" do
        let(:tokens) do
          [
            Token.new(Token::INTEGER, 2),
            Token.new(Token::MUL, "*"),
            Token.new(Token::INTEGER, 3)
          ]
        end

        it do
          expect(
            subject.send(:term).to_s
          ).to eql("BinOp(Num(Token(INTEGER, 2)), Token(MUL, *), Num(Token(INTEGER, 3)))")
        end
      end
    end

    describe "#expression" do # rubocop:disable Metrics/BlockLength
      let(:lexer) { instance_double("Ruslanspivak::Lexer") }

      subject { described_class.new(lexer) }

      before do
        allow(lexer).to receive(:next_token).and_return(*tokens)
      end

      context "with only an operand" do
        let(:tokens) do
          [
            Token.new(Token::INTEGER, 2)
          ]
        end

        it "should return the operand" do
          expect(subject.send(:expression)).to eql(Num.new(Token.new(Token::INTEGER, 2)))
        end
      end

      context "with operation" do
        let(:tokens) do
          [
            Token.new(Token::INTEGER, 2),
            Token.new(Token::PLUS, "+"),
            Token.new(Token::INTEGER, 3)
          ]
        end

        it do
          expect(
            subject.send(:expression).to_s
          ).to eql("BinOp(Num(Token(INTEGER, 2)), Token(PLUS, +), Num(Token(INTEGER, 3)))")
        end
      end
    end
  end
end
