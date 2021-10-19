# typed: false
require 'domain_helper'

module Issue
  module Types
    RSpec.describe Task do
      describe '.initial_status' do
        it { expect(described_class.initial_status).to eq ::Issue::Statuses::Preparation }
      end

      describe '.prepared?' do
        let(:criteria_any) { acceptance_criteria(%w(CRT)) }
        let(:criteria_empty) { acceptance_criteria([]) }
        let(:size_any) { StoryPoint.new(5) }
        let(:size_unknown) { StoryPoint.unknown }

        context 'cirteira >= 1 and size == unknown' do
          it do
            expect(described_class.prepared?(criteria_any, size_unknown)).to be true
          end
        end

        context 'cirteira >= 1 and size != unknown' do
          it do
            expect(described_class.prepared?(criteria_any, size_any)).to be true
          end
        end

        context 'cirteira == 0 and size != unknown' do
          it do
            expect(described_class.prepared?(criteria_empty, size_any)).to be true
          end
        end

        context 'cirteira == 0 and size == unknown' do
          it do
            expect(described_class.prepared?(criteria_empty, size_unknown)).to be true
          end
        end
      end

      describe '.must_have_acceptance_criteria?' do
        it { expect(described_class).to_not be_must_have_acceptance_criteria }
      end
    end
  end
end
