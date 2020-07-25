# typed: false
module I18nHelper
  def t_domain_error(exception_class)
    key = exception_class.to_s.underscore.tr('/', '.')
    I18n.t(key, scope: 'domain.errors')
  end
end
