# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: ignore
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/actionmailbox/all/actionmailbox.rbi
#
# actionmailbox-6.1.4.1

module Mail
  def self.from_source(source); end
end
class Mail::Address
  def ==(other_address); end
  def self.wrap(address); end
end
class Mail::Message
  def bcc_addresses; end
  def cc_addresses; end
  def from_address; end
  def recipients; end
  def recipients_addresses; end
  def to_addresses; end
  def x_original_to_addresses; end
end
module ActionMailbox
  def incinerate; end
  def incinerate=(val); end
  def incinerate_after; end
  def incinerate_after=(val); end
  def ingress; end
  def ingress=(val); end
  def logger; end
  def logger=(val); end
  def queues; end
  def queues=(val); end
  def self.incinerate; end
  def self.incinerate=(val); end
  def self.incinerate_after; end
  def self.incinerate_after=(val); end
  def self.ingress; end
  def self.ingress=(val); end
  def self.logger; end
  def self.logger=(val); end
  def self.queues; end
  def self.queues=(val); end
  def self.railtie_helpers_paths; end
  def self.railtie_namespace; end
  def self.railtie_routes_url_helpers(include_path_helpers = nil); end
  def self.table_name_prefix; end
  def self.use_relative_model_naming?; end
  extend ActiveSupport::Autoload
end
class ActionMailbox::Engine < Rails::Engine
end
module ActionMailbox::Callbacks
  extend ActiveSupport::Concern
  include ActiveSupport::Callbacks
end
module ActionMailbox::Callbacks::ClassMethods
  def after_processing(*methods, &block); end
  def around_processing(*methods, &block); end
  def before_processing(*methods, &block); end
end
module ActionMailbox::Routing
  extend ActiveSupport::Concern
end
module ActionMailbox::Routing::ClassMethods
  def mailbox_for(inbound_email); end
  def route(inbound_email); end
  def routing(routes); end
end
class ActionMailbox::Router::Route
  def address; end
  def ensure_valid_address; end
  def initialize(address, to:); end
  def mailbox_class; end
  def mailbox_name; end
  def match?(inbound_email); end
end
class ActionMailbox::Router
  def add_route(address, to:); end
  def add_routes(routes); end
  def initialize; end
  def mailbox_for(inbound_email); end
  def route(inbound_email); end
  def routes; end
end
class ActionMailbox::Router::RoutingError < StandardError
end
class ActionMailbox::Base
  def __callbacks; end
  def __callbacks?; end
  def _process_callbacks; end
  def _run_process_callbacks(&block); end
  def bounce_with(message); end
  def bounced!(**, &&); end
  def delivered!(**, &&); end
  def finished_processing?; end
  def inbound_email; end
  def initialize(inbound_email); end
  def logger(**, &&); end
  def mail(**, &&); end
  def perform_processing; end
  def process; end
  def rescue_handlers; end
  def rescue_handlers=(arg0); end
  def rescue_handlers?; end
  def router; end
  def router=(val); end
  def self.__callbacks; end
  def self.__callbacks=(value); end
  def self.__callbacks?; end
  def self._process_callbacks; end
  def self._process_callbacks=(value); end
  def self.receive(inbound_email); end
  def self.rescue_handlers; end
  def self.rescue_handlers=(value); end
  def self.rescue_handlers?; end
  def self.router; end
  def self.router=(val); end
  def track_status_of_inbound_email; end
  extend ActionMailbox::Callbacks::ClassMethods
  extend ActionMailbox::Routing::ClassMethods
  extend ActiveSupport::Callbacks::ClassMethods
  extend ActiveSupport::DescendantsTracker
  extend ActiveSupport::Rescuable::ClassMethods
  include ActionMailbox::Callbacks
  include ActiveSupport::Callbacks
  include ActiveSupport::Rescuable
end
module ActionMailbox::TestHelper
  def create_inbound_email_from_fixture(fixture_name, status: nil); end
  def create_inbound_email_from_mail(status: nil, **mail_options, &block); end
  def create_inbound_email_from_source(source, status: nil); end
  def receive_inbound_email_from_fixture(*args); end
  def receive_inbound_email_from_mail(**kwargs, &block); end
  def receive_inbound_email_from_source(*args); end
end
class ActionMailbox::TestCase < ActiveSupport::TestCase
  include ActionMailbox::TestHelper
end
