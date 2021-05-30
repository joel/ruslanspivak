# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Parser do
    let(:input)  { "30 * 7 / 2" }
    let(:result) { 105 }
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
