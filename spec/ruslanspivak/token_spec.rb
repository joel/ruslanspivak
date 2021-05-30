# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Token do
    let(:type) { Token::INTEGER }
    let(:value) { 1 }

    subject do
      described_class.new(type, value)
    end

    describe "#to_s" do
      it do
        expect(subject.to_s).to eql("Token(INTEGER, 1)")
      end
    end

    describe "#==" do
      it do
        expect(subject).to eql(described_class.new(Token::INTEGER, 1))
      end
    end
  end
end
