# typed: false
module ExpectationSupport
  def expect_activity_permission_error(roles, &action)
    roles.each do |role|
      expect { yield(role) }.to raise_error Activity::PermissionDenied
    end
  end
end

RSpec.configure do |c|
  c.include ExpectationSupport
end
