# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: ignore
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/omniauth-rails_csrf_protection/all/omniauth-rails_csrf_protection.rbi
#
# omniauth-rails_csrf_protection-1.0.0

module OmniAuth
end
module OmniAuth::RailsCsrfProtection
end
class OmniAuth::RailsCsrfProtection::TokenVerifier
  def __callbacks; end
  def __callbacks?; end
  def _helper_methods; end
  def _helper_methods=(arg0); end
  def _helper_methods?; end
  def _process_action_callbacks; end
  def _run_process_action_callbacks(&block); end
  def allow_forgery_protection; end
  def allow_forgery_protection=(value); end
  def call(env); end
  def default_protect_from_forgery; end
  def default_protect_from_forgery=(value); end
  def forgery_protection_origin_check; end
  def forgery_protection_origin_check=(value); end
  def forgery_protection_strategy; end
  def forgery_protection_strategy=(value); end
  def log_warning_on_csrf_failure; end
  def log_warning_on_csrf_failure=(value); end
  def params(*args, &block); end
  def per_form_csrf_tokens; end
  def per_form_csrf_tokens=(value); end
  def request; end
  def request_forgery_protection_token; end
  def request_forgery_protection_token=(value); end
  def self.__callbacks; end
  def self.__callbacks=(value); end
  def self.__callbacks?; end
  def self._helper_methods; end
  def self._helper_methods=(value); end
  def self._helper_methods?; end
  def self._helpers; end
  def self._process_action_callbacks; end
  def self._process_action_callbacks=(value); end
  def self.allow_forgery_protection; end
  def self.allow_forgery_protection=(value); end
  def self.default_protect_from_forgery; end
  def self.default_protect_from_forgery=(value); end
  def self.forgery_protection_origin_check; end
  def self.forgery_protection_origin_check=(value); end
  def self.forgery_protection_strategy; end
  def self.forgery_protection_strategy=(value); end
  def self.log_warning_on_csrf_failure; end
  def self.log_warning_on_csrf_failure=(value); end
  def self.per_form_csrf_tokens; end
  def self.per_form_csrf_tokens=(value); end
  def self.request_forgery_protection_token; end
  def self.request_forgery_protection_token=(value); end
  def self.urlsafe_csrf_tokens; end
  def self.urlsafe_csrf_tokens=(value); end
  def session(*args, &block); end
  def urlsafe_csrf_tokens; end
  extend AbstractController::Callbacks::ClassMethods
  extend AbstractController::Helpers::ClassMethods
  extend ActionController::RequestForgeryProtection::ClassMethods
  extend ActiveSupport::Callbacks::ClassMethods
  extend ActiveSupport::Configurable::ClassMethods
  extend ActiveSupport::DescendantsTracker
  include AbstractController::Callbacks
  include AbstractController::Helpers
  include ActionController::RequestForgeryProtection
  include ActiveSupport::Callbacks
  include ActiveSupport::Configurable
end
module OmniAuth::RailsCsrfProtection::TokenVerifier::HelperMethods
  def form_authenticity_token(*args, &block); end
  def protect_against_forgery?(*args, &block); end
end
class OmniAuth::RailsCsrfProtection::Railtie < Rails::Railtie
end
