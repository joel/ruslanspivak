module Ruslanspivak
  RSpec.describe Main do
    describe '#ruslanspivak' do
      context 'Example 1' do
        let(:input) { 'foo' }
        let(:result) { 'foo' }
        it do
          expect(subject.ruslanspivak(input)).to eql(result)
        end
      end
    end
  end
end
