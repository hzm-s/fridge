# typed: false
require 'domain_helper'

module Pbi
  class Types
    describe Issue do
      describe 'query to prepared' do
        let(:criteria_any) { acceptance_criteria(%w(CRT)) }
        let(:criteria_empty) { acceptance_criteria([]) }
        let(:size_any) { StoryPoint.new(5) }
        let(:size_unknown) { StoryPoint.unknown }

        it do
          expect(described_class.prepared?(criteria_any, size_any)).to be true
        end

        it do
          expect(described_class.prepared?(criteria_any, size_unknown)).to be true
        end

        it do
          expect(described_class.prepared?(criteria_empty, size_unknown)).to be true
        end

        it do
          expect(described_class.prepared?(criteria_empty, size_any)).to be true
        end
      end
    end
  end
end
