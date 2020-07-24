# typed: false
require 'rails_helper'

RSpec.describe App::TeamMemberInvitation do
  it do
    product = Dao::Product.create!(name: 'product')

    invitation = described_class.create_for_product(product.id)

    expect { described_class.create_for_product(product.id) }
      .to change { described_class.count }.by(0)
  end
end
