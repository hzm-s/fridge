# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: true
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/jwt/all/jwt.rbi
#
# jwt-2.2.3

module JWT
  def decode(jwt, key = nil, verify = nil, options = nil, &keyfinder); end
  def encode(payload, key, algorithm = nil, header_fields = nil); end
  def self.decode(jwt, key = nil, verify = nil, options = nil, &keyfinder); end
  def self.encode(payload, key, algorithm = nil, header_fields = nil); end
  include JWT::DefaultOptions
end
class JWT::Base64
  def self.url_decode(str); end
  def self.url_encode(str); end
end
class JWT::JSON
  def self.generate(data); end
  def self.parse(data); end
end
module JWT::SecurityUtils
  def asn1_to_raw(signature, public_key); end
  def raw_to_asn1(signature, private_key); end
  def rbnacl_fixup(algorithm, key); end
  def secure_compare(left, right); end
  def self.asn1_to_raw(signature, public_key); end
  def self.raw_to_asn1(signature, private_key); end
  def self.rbnacl_fixup(algorithm, key); end
  def self.secure_compare(left, right); end
  def self.verify_ps(algorithm, public_key, signing_input, signature); end
  def self.verify_rsa(algorithm, public_key, signing_input, signature); end
  def verify_ps(algorithm, public_key, signing_input, signature); end
  def verify_rsa(algorithm, public_key, signing_input, signature); end
end
module JWT::Algos
  def find(algorithm); end
  def indexed; end
  extend JWT::Algos
end
module JWT::Algos::Hmac
  def self.sign(to_sign); end
  def self.verify(to_verify); end
  def sign(to_sign); end
  def verify(to_verify); end
end
module JWT::Algos::Eddsa
  def self.sign(to_sign); end
  def self.verify(to_verify); end
  def sign(to_sign); end
  def verify(to_verify); end
end
module JWT::Algos::Ecdsa
  def self.sign(to_sign); end
  def self.verify(to_verify); end
  def sign(to_sign); end
  def verify(to_verify); end
end
module JWT::Algos::Rsa
  def self.sign(to_sign); end
  def self.verify(to_verify); end
  def sign(to_sign); end
  def verify(to_verify); end
end
module JWT::Algos::Ps
  def require_openssl!; end
  def self.require_openssl!; end
  def self.sign(to_sign); end
  def self.verify(to_verify); end
  def sign(to_sign); end
  def verify(to_verify); end
end
module JWT::Algos::None
  def self.sign(*arg0); end
  def self.verify(*arg0); end
  def sign(*arg0); end
  def verify(*arg0); end
end
module JWT::Algos::Unsupported
  def self.sign(*arg0); end
  def self.verify(*arg0); end
  def sign(*arg0); end
  def verify(*arg0); end
end
module JWT::Signature
  def sign(algorithm, msg, key); end
  def verify(algorithm, key, signing_input, signature); end
  extend JWT::Signature
end
class JWT::Signature::ToSign < Struct
  def algorithm; end
  def algorithm=(_); end
  def key; end
  def key=(_); end
  def msg; end
  def msg=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
end
class JWT::Signature::ToVerify < Struct
  def algorithm; end
  def algorithm=(_); end
  def public_key; end
  def public_key=(_); end
  def self.[](*arg0); end
  def self.inspect; end
  def self.members; end
  def self.new(*arg0); end
  def signature; end
  def signature=(_); end
  def signing_input; end
  def signing_input=(_); end
end
class JWT::EncodeError < StandardError
end
class JWT::DecodeError < StandardError
end
class JWT::RequiredDependencyError < StandardError
end
class JWT::VerificationError < JWT::DecodeError
end
class JWT::ExpiredSignature < JWT::DecodeError
end
class JWT::IncorrectAlgorithm < JWT::DecodeError
end
class JWT::ImmatureSignature < JWT::DecodeError
end
class JWT::InvalidIssuerError < JWT::DecodeError
end
class JWT::InvalidIatError < JWT::DecodeError
end
class JWT::InvalidAudError < JWT::DecodeError
end
class JWT::InvalidSubError < JWT::DecodeError
end
class JWT::InvalidJtiError < JWT::DecodeError
end
class JWT::InvalidPayload < JWT::DecodeError
end
class JWT::JWKError < JWT::DecodeError
end
class JWT::Verify
  def exp_leeway; end
  def global_leeway; end
  def initialize(payload, options); end
  def nbf_leeway; end
  def self.verify_aud(payload, options); end
  def self.verify_claims(payload, options); end
  def self.verify_expiration(payload, options); end
  def self.verify_iat(payload, options); end
  def self.verify_iss(payload, options); end
  def self.verify_jti(payload, options); end
  def self.verify_not_before(payload, options); end
  def self.verify_sub(payload, options); end
  def verify_aud; end
  def verify_expiration; end
  def verify_iat; end
  def verify_iss; end
  def verify_jti; end
  def verify_not_before; end
  def verify_sub; end
end
class JWT::Decode
  def allowed_algorithms; end
  def decode_crypto; end
  def decode_segments; end
  def find_key(&keyfinder); end
  def header; end
  def initialize(jwt, key, verify, options, &keyfinder); end
  def options_includes_algo_in_header?; end
  def parse_and_decode(segment); end
  def payload; end
  def segment_length; end
  def signing_input; end
  def validate_segment_count!; end
  def verify_claims; end
  def verify_signature; end
end
module JWT::DefaultOptions
end
class JWT::ClaimsValidator
  def initialize(payload); end
  def validate!; end
  def validate_is_numeric(claim); end
  def validate_numeric_claims; end
end
class JWT::Encode
  def combine(*parts); end
  def encode(data); end
  def encode_header; end
  def encode_payload; end
  def encode_signature; end
  def encoded_header; end
  def encoded_header_and_payload; end
  def encoded_payload; end
  def encoded_signature; end
  def initialize(options); end
  def segments; end
end
module JWT::JWK
  def self.classes; end
  def self.create_from(keypair); end
  def self.generate_mappings; end
  def self.import(jwk_data); end
  def self.mappings; end
  def self.new(keypair); end
end
class JWT::JWK::KeyFinder
  def find_key(kid); end
  def initialize(options); end
  def jwks; end
  def jwks_keys; end
  def key_for(kid); end
  def load_keys(opts = nil); end
  def reloadable?; end
  def resolve_key(kid); end
end
class JWT::JWK::KeyBase
  def initialize(keypair, kid = nil); end
  def keypair; end
  def kid; end
  def self.inherited(klass); end
end
class JWT::JWK::EC < JWT::JWK::KeyBase
  def append_private_parts(the_hash); end
  def encode_octets(octets); end
  def encode_open_ssl_bn(key_part); end
  def export(options = nil); end
  def generate_kid(ec_keypair); end
  def initialize(keypair, kid = nil); end
  def keypair_components(ec_keypair); end
  def private?; end
  def public_key(*args, &block); end
  def self.decode_octets(jwk_data); end
  def self.decode_open_ssl_bn(jwk_data); end
  def self.ec_pkey(jwk_crv, jwk_x, jwk_y, jwk_d); end
  def self.import(jwk_data); end
  def self.jwk_attrs(jwk_data, attrs); end
  def self.to_openssl_curve(crv); end
  extend Forwardable
end
class JWT::JWK::RSA < JWT::JWK::KeyBase
  def append_private_parts(the_hash); end
  def encode_open_ssl_bn(key_part); end
  def export(options = nil); end
  def generate_kid(public_key); end
  def initialize(keypair, kid = nil); end
  def private?; end
  def public_key; end
  def self.decode_open_ssl_bn(jwk_data); end
  def self.import(jwk_data); end
  def self.jwk_attributes(jwk_data, *attributes); end
  def self.populate_key(rsa_key, rsa_parameters); end
  def self.rsa_pkey(rsa_parameters); end
end
class JWT::JWK::HMAC < JWT::JWK::KeyBase
  def export(options = nil); end
  def generate_kid; end
  def initialize(keypair, kid = nil); end
  def private?; end
  def public_key; end
  def self.import(jwk_data); end
end
