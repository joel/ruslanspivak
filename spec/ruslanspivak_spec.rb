# frozen_string_literal: true

RSpec.describe Ruslanspivak do
  let(:input)       { "7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)" }
  let(:result)      { 10 }
  let(:lexer)       { Ruslanspivak::Lexer.new(input) }
  let(:parser)      { Ruslanspivak::Parser.new(lexer) }
  let(:interpreter) { Ruslanspivak::Interpreter.new(parser) }

  it do
    expect(interpreter.interpret).to eql(result)
  end
end
