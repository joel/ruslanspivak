# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Parser do
    let(:input)  { "7 + 3 * (10 / (12 / (3 + 1) - 1)) / (2 + 3) - 5 - 3 + (8)" }
    let(:result) { 10 }
    let(:lexer)  { Lexer.new(input) }

    subject do
      described_class.new(lexer)
    end

    describe "#parse" do
      it do
        expect(subject.parse).to eql(result)
      end
    end
  end
end
