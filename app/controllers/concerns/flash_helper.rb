# typed: false
module FlashHelper
  def flash_success(i18n_key_or_msg)
    flash_params(:success, i18n_key_or_msg)
  end

  def flash_error(i18n_key_or_msg)
    flash_params(:error, i18n_key_or_msg)
  end

  def feedback_message(key)
    I18n.t(Array(key).map(&:to_s).join('.'), scope: 'feedbacks')
  end

  private

  def flash_params(type, i18n_key_or_msg)
    { type.to_sym => build_message(i18n_key_or_msg) }
  end

  def build_message(i18n_key_or_msg)
    return i18n_key_or_msg if i18n_key_or_msg.is_a?(String)

    feedback_message(i18n_key_or_msg)
  end
end
