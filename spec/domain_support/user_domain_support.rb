# typed: false
module UserDomainSupport
  def register_user(name: 'User Name', email: 'us@example.com')
    User::User.create(name, email)
  end

  def user_id(str)
    User::Id.from_string(str)
  end
end

RSpec.configure do |c|
  c.include UserDomainSupport
end
