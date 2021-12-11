# typed: false
require_relative '../domain_support/sbi_domain_support'

module SbiSupport
end

RSpec.configure do |c|
  c.include SbiSupport
end
