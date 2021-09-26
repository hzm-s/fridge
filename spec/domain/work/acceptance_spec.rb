# typed: false
require 'domain_helper'

module Work
  RSpec.describe Acceptance do
    describe 'Satisfy' do
      let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

      it do
        type = Issue::Types::Feature
        a = described_class.new(type, criteria, [].to_set)
        expect(a.satisfy(2)).to eq described_class.new(type, criteria, [2].to_set)
      end

      it do
        a = described_class.new(Issue::Types::Feature, criteria, [].to_set)
        expect { a.satisfy(7) }.to raise_error AcceptanceCriterionNotFound
      end

      it do
        a = described_class.new(Issue::Types::Feature, criteria, [1, 2].to_set)
        expect { a.satisfy(1) }.to raise_error AlreadySatisfied
      end
    end

    describe 'Dissatisfy' do
      let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

      it do
        type = Issue::Types::Feature
        a = described_class.new(type, criteria, [1, 2, 3].to_set)
        expect(a.dissatisfy(2)).to eq described_class.new(type, criteria, [1, 3].to_set)
      end

      it do
        a = described_class.new(Issue::Types::Feature, criteria, [1, 2, 3].to_set)
        expect { a.dissatisfy(7) }.to raise_error AcceptanceCriterionNotFound
      end

      it do
        a = described_class.new(Issue::Types::Feature, criteria, [3].to_set)
        expect { a.dissatisfy(1) }.to raise_error NotSatisfied
      end
    end

    describe 'Status' do
      let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }

      context 'type = feature, all satisfied = no' do
        it do
          a = described_class.new(Issue::Types::Feature, criteria, [1, 3].to_set)

          aggregate_failures do
            expect(a.status).to eq Status::NotAccepted
            expect(a.avaiable_activities).to eq activity_set([:accept_feature])
          end
        end
      end

      context 'type = feature, all satisfied = yes' do
        it do
          a = described_class.new(Issue::Types::Feature, criteria, [1, 2, 3].to_set)

          aggregate_failures do
            expect(a.status).to eq Status::Acceptable
            expect(a.avaiable_activities).to eq activity_set([:accept_feature])
          end
        end
      end

      context 'type = task, size >= 1, all satisfied = no' do
        it do
          a = described_class.new(Issue::Types::Task, criteria, [3].to_set)

          aggregate_failures do
            expect(a.status).to eq Status::NotAccepted
            expect(a.avaiable_activities).to eq activity_set([:accept_task])
          end
        end
      end

      context 'type = task, size >= 1, all satisfied = yes' do
        it do
          a = described_class.new(Issue::Types::Task, criteria, [1, 2, 3].to_set)

          aggregate_failures do
            expect(a.status).to eq Status::Acceptable
            expect(a.avaiable_activities).to eq activity_set([:accept_task])
          end
        end
      end

      context 'type = task, size = 0' do
        it do
          a = described_class.new(Issue::Types::Task, acceptance_criteria([]), [].to_set)

          aggregate_failures do
            expect(a.status).to eq Status::Acceptable
            expect(a.avaiable_activities).to eq activity_set([:accept_task])
          end
        end
      end
    end
  end
end
