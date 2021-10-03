# typed: false
require 'domain_helper'

module Work
  RSpec.describe Statuses do
    describe '.initial' do
      let(:feature_type) { Issue::Types::Feature }
      let(:task_type) { Issue::Types::Task }
      let(:criteria) { acceptance_criteria(%w(CRT)) }

      context 'type = feature' do
        it do
          s = described_class.initial(feature_type, criteria)
          expect(s).to eq Statuses::NotAccepted.new(feature_type)
        end
      end

      context 'type = task, criteria is NOT empty' do
        it do
          s = described_class.initial(task_type, criteria)
          expect(s).to eq Statuses::NotAccepted.new(task_type)
        end
      end

      context 'type = task, criteria is empty' do
        it do
          s = described_class.initial(task_type, acceptance_criteria([]))
          expect(s).to eq Statuses::Acceptable.new(task_type)
        end
      end
    end
  end
end
