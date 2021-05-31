# frozen_string_literal: true

module Ruslanspivak
  RSpec.describe NodeVisitor do # rubocop:disable Metrics/BlockLength
    describe "#visit" do # rubocop:disable Metrics/BlockLength
      let(:instance) do
        Class.new(Ruslanspivak::NodeVisitor) do
          def visit_foo(_node)
            :foo
          end
        end.new
      end

      let(:node) { instance_double("Ruslanspivak::Node") }

      RSpec.shared_examples "stubbed method visit" do
        before do
          expect(instance).to receive(:visit_foo).with(node).and_call_original
        end
      end

      context "implemented method" do
        include_examples "stubbed method visit"

        before do
          allow(node).to receive(:type) { :foo }
        end

        it "call and return method value" do
          expect(instance.visit(node)).to eql(:foo)
        end
      end

      context "not implemented method" do
        # include_examples "stubbed method visit"

        before do
          allow(node).to receive(:type) { :bar }
        end

        it "call and throw error " do
          expect do
            instance.visit(node)
          end.to raise_error("No visit_{} method visit_bar")
        end
      end
    end
  end
end
