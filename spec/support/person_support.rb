# typed: false
require_relative '../domain_support/person_domain_support'

module PersonSupport
  def sign_up_as_person(attrs = default_attrs)
    RegisterPersonUsecase.perform(attrs[:name], attrs[:email], attrs[:oauth_info])
      .yield_self { |id| App::UserAccount.find(id) }
      .yield_self { |ua| Person::Id.from_string(ua.dao_person_id) }
      .yield_self { |pid| PersonRepository::AR.find_by_id(pid) }
  end

  private

  def default_attrs
    auth_hash = mock_auth_hash
    {
      name: auth_hash['info']['name'],
      email: auth_hash['info']['email'],
      oauth_info: {
        provider: auth_hash['provider'],
        uid: auth_hash['uid'],
        image: 'https://ima.ge/123'
      }
    }
  end
end

RSpec.configure do |c|
  c.include PersonSupport
end
