# typed: false
require 'domain_helper'

module Pbi
  class Statuses
    RSpec.describe Wip do
      describe 'available activities' do
        it do
          expect(described_class.available_activities).to eq activity_set([
            :revert_pbi_from_sprint,
          ])
        end
      end

      describe 'update by preparation' do
        let(:type) { Types.from_string('feature') }
        let(:criteria) { acceptance_criteria(%w(AC1 AC2 AC3)) }
        let(:point) { StoryPoint.new(5) }

        it do
          status = described_class.update_by_preparation(type, criteria, point)
          expect(status).to eq described_class
        end
      end

      describe 'assign to sprint' do
        it do
          status = described_class.assign_to_sprint
          expect(status).to eq described_class
        end
      end
    end
  end
end
