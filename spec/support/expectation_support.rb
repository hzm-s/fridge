# typed: false
module ExpectationSupport
  def expect_to_include_domain_error(form, attr, i18n_key, scope: 'domain.errors')
    expect(form.errors[attr]).to include(I18n.t(i18n_key, scope: scope))
  end

  def expect_to_include_domain_shared_error(form, attr, i18n_key)
    expect_to_include_domain_error(form, attr, i18n_key, scope: 'domain.errors.shared')
  end
end

RSpec.configure do |c|
  c.include ExpectationSupport
end
