# typed: false
require 'domain_helper'

module Work
  describe TaskStatus do
    describe 'Query next activity' do
      subject { status.next_activity }

      context 'when todo' do
        let(:status) { described_class.from_string('todo') }
        it { is_expected.to eq activity(:start_task) }
      end

      context 'when wip' do
        let(:status) { described_class.from_string('wip') }
        it { is_expected.to eq activity(:complete_task) }
      end

      context 'when wait' do
        let(:status) { described_class.from_string('wait') }
        it { is_expected.to eq activity(:resume_task) }
      end

      context 'when done' do
        let(:status) { described_class.from_string('done') }
        it { is_expected.to be_nil }
      end
    end

    describe 'Query available activities' do
      subject { status.available_activities }

      context 'when todo' do
        let(:status) { described_class.from_string('todo') }
        it { is_expected.to eq activity_set([:start_task, :update_task]) }
      end

      context 'when wip' do
        let(:status) { described_class.from_string('wip') }
        it { is_expected.to eq activity_set([:complete_task, :suspend_task, :update_task]) }
      end

      context 'when wait' do
        let(:status) { described_class.from_string('wait') }
        it { is_expected.to eq activity_set([:resume_task, :update_task]) }
      end

      context 'when done' do
        let(:status) { described_class.from_string('done') }
        it { is_expected.to eq activity_set([]) }
      end
    end
  end
end
