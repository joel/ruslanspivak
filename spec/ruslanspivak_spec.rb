# frozen_string_literal: true

RSpec.describe Ruslanspivak do
  let(:lexer)       { Ruslanspivak::Lexer.new(input) }
  let(:parser)      { Ruslanspivak::Parser.new(lexer) }
  let(:interpreter) { Ruslanspivak::Interpreter.new(parser) }

  context "" do
    let(:input)  { "7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)" }
    let(:result) { 10 }
    it do
      expect(interpreter.interpret).to eql(result)
    end
  end

  context "" do
    let(:input)  { "5 - - - 2" }
    let(:result) { 3 }
    it do
      expect(interpreter.interpret).to eql(result)
    end
  end
end
