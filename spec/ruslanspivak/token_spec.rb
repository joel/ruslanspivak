# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe Token do
    describe "#ruslanspivak" do
      context "Example 1" do
        let(:type)  { Token::INTEGER }
        let(:value) { 1 }

        subject do
          described_class.new(type, value)
        end
        it do
          expect(subject.to_s).to eql("Token(INTEGER, 1)")
        end
      end
    end
  end
end
