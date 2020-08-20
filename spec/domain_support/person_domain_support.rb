# typed: false
require 'securerandom'

module PersonDomainSupport
  def register_person(name: 'User Name', email: "#{SecureRandom.hex}@example.com")
    Person::Person.create(name, email)
  end

  def person_id(str)
    Person::Id.from_string(str)
  end
end

RSpec.configure do |c|
  c.include PersonDomainSupport
end
