# typed: false
class App::TeamMemberInvitation < ApplicationRecord
  class << self
    def create_for_product(product_id)
      find_or_create_by!(dao_product_id: product_id)
    end
  end

  def generate_url(base_url)
    (URI.parse(base_url) + id).to_s
  end
end
