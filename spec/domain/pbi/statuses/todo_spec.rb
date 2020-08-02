# typed: false
require 'rails_helper'

module Pbi
  module Statuses
    RSpec.describe Todo do
      describe '#can_assign?' do
        it do
          expect(described_class).to_not be_can_assign
        end
      end

      describe '#update_to_todo' do
        it do
          expect { described_class.update_to_todo }
            .to raise_error AssignProductBacklogItemNotAllowed
        end
      end
    end
  end
end
