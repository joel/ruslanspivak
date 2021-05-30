# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Parser do
    let(:input)  { "14 + 2 * 3 - 6 / 2" }
    let(:result) { 17 }
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
