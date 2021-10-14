# typed: false
require 'domain_helper'

module Work
  module Statuses
    RSpec.describe Acceptable do
      describe '.available_activities' do
        it do
          expect(described_class.available_activities).to eq activity_set([
            :accept_feature,
            :accept_task,
          ])
        end
      end

      describe '.update_by_acceptance' do
        let(:criteria) { acceptance_criteria(%w(CRT)) }
        let(:all_satisfied) { Acceptance.new(criteria, [1].to_set) }
        let(:not_all_satisfied) { Acceptance.new(criteria, [].to_set) }

        context 'all_satisfied = yes' do
          it do
            expect(described_class.update_by_acceptance(all_satisfied)).to eq described_class
          end
        end

        context 'all_satisfied = no' do
          it do
            expect(described_class.update_by_acceptance(not_all_satisfied)).to eq NotAccepted
          end
        end
      end

      describe '.accept' do
        it { expect(described_class.accept).to eq Accepted }
      end

      describe '.can_accept?' do
        it { expect(described_class).to be_can_accept }
      end
    end
  end
end
