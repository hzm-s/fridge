# typed: false
module PersonDomainSupport
  def register_person(name: 'User Name', email: 'us@example.com')
    Person::Person.create(name, email)
  end

  def person_id(str)
    Person::Id.from_string(str)
  end
end

RSpec.configure do |c|
  c.include PersonDomainSupport
end
