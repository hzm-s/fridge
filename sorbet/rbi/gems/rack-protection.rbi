# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/rack-protection/all/rack-protection.rbi
#
# rack-protection-2.1.0

module Rack
end
module Rack::Protection
  def self.new(app, options = nil); end
end
class Rack::Protection::Base
  def accepts?(env); end
  def app; end
  def call(env); end
  def default_options; end
  def default_reaction(env); end
  def deny(env); end
  def drop_session(env); end
  def encrypt(value); end
  def html?(headers); end
  def initialize(app, options = nil); end
  def instrument(env); end
  def options; end
  def origin(env); end
  def random_string(secure = nil); end
  def react(env); end
  def referrer(env); end
  def report(env); end
  def safe?(env); end
  def secure_compare(a, b); end
  def self.default_options(options); end
  def self.default_reaction(reaction); end
  def session(env); end
  def session?(env); end
  def warn(env, message); end
end
class Rack::Protection::AuthenticityToken < Rack::Protection::Base
  def accepts?(env); end
  def compare_with_real_token(token, session); end
  def decode_token(token); end
  def default_options; end
  def encode_token(token); end
  def mask_authenticity_token(session); end
  def mask_token(token); end
  def masked_token?(token); end
  def real_token(session); end
  def self.random_token; end
  def self.token(session); end
  def set_token(session); end
  def unmask_token(masked_token); end
  def unmasked_token?(token); end
  def valid_token?(session, token); end
  def xor_byte_strings(s1, s2); end
end
