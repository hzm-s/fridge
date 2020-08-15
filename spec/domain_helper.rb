# typed: false
require 'spec_helper'
$LOAD_PATH << File.expand_path('../domain', __dir__)

require 'shared'
require 'product'
require 'plan'
require 'release'
require 'pbi'
require 'team'
require 'user'

Dir[File.join(File.expand_path('./domain_support', __dir__), '**', '*.rb')].sort.each { |f| require f }
