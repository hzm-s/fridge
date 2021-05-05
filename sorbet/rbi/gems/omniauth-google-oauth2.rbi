# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/omniauth-google-oauth2/all/omniauth-google-oauth2.rbi
#
# omniauth-google-oauth2-1.0.0

module OmniAuth
end
module OmniAuth::Strategies
end
class OmniAuth::Strategies::GoogleOauth2 < OmniAuth::Strategies::OAuth2
  def authorize_params; end
  def build_access_token; end
  def callback_url; end
  def client_get_token(verifier, redirect_uri); end
  def custom_build_access_token; end
  def get_access_token(request); end
  def get_scope(params); end
  def get_token_options(redirect_uri = nil); end
  def get_token_params; end
  def image_params; end
  def image_size_opts_passed?; end
  def image_url; end
  def prune!(hash); end
  def raw_info; end
  def strip_unnecessary_query_parameters(query_parameters); end
  def verified_email; end
  def verify_hd(access_token); end
  def verify_token(access_token); end
  extend OmniAuth::Strategy::ClassMethods
end
