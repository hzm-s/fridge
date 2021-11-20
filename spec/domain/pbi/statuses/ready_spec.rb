# typed: false
require 'domain_helper'

module Pbi
  class Statuses
    RSpec.describe Ready do
      describe 'available activities' do
        it do
          expect(described_class.available_activities).to eq activity_set([
            :prepare_acceptance_criteria,
            :remove_pbi,
            :estimate_pbi,
            :assign_pbi_to_sprint,
          ])
        end
      end

      describe 'update by preparation' do
        let(:type) { Types.from_string('feature') }
        let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }
        let(:point) { StoryPoint.new(5) }
        let(:empty_criteria) { acceptance_criteria([]) }
        let(:unknown_point) { StoryPoint.new(nil) }

        context 'when prepared' do
          it do
            status = described_class.update_by_preparation(type, criteria, point)
            expect(status).to eq Ready
          end
        end

        context 'when NOT prepared' do
          it do
            status = described_class.update_by_preparation(type, empty_criteria, unknown_point)
            expect(status).to eq Preparation
          end
        end
      end
    end
  end
end
