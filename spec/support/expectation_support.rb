# typed: false
module ExpectationSupport
  def expect_to_include_domain_error(form, attr, keys, scope: 'domain.errors')
    i18n_key = keys.pop
    i18n_scope = "#{scope}.#{keys.map(&:to_s).join('.')}"
    message = I18n.t(i18n_key, scope: i18n_scope)
    expect(form.errors[attr]).to include(message)
  end
end

RSpec.configure do |c|
  c.include ExpectationSupport
end
