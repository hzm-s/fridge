# typed: false
require 'domain_helper'

module Work
  RSpec.describe TaskStatus do
    describe 'Query next activity' do
      let(:status) { described_class.from_string(status_name) }

      context 'when todo' do
        let(:status_name) { 'todo' }

        it do
          expect(status.next_activity).to eq activity(:start_task)
        end
      end

      context 'when wip' do
        let(:status_name) { 'wip' }

        it do
          expect(status.next_activity).to eq activity(:complete_task)
        end
      end

      context 'when wait' do
        let(:status_name) { 'wait' }

        it do
          expect(status.next_activity).to eq activity(:resume_task)
        end
      end

      context 'when done' do
        let(:status_name) { 'done' }

        it do
          expect(status.next_activity).to be_nil
        end
      end
    end
  end
end
