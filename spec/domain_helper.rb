# typed: false
require 'spec_helper'
$LOAD_PATH << File.expand_path('../domain', __dir__)

Dir[File.join(File.expand_path('./domain_support', __dir__), '**', '*.rb')].sort.each { |f| require f }

require 'shared'
require 'team'
require 'user'

def register_user(name: 'User Name', email: 'us@example.com')
  User::User.create(name, email)
end
