# typed: false
require 'spec_helper'
$LOAD_PATH << File.expand_path('../domain', __dir__)

require 'shared'
require 'person'
require 'team'
require 'product'
require 'feature'
require 'product_backlog'
require 'release'

Dir[File.join(File.expand_path('./domain_support', __dir__), '**', '*.rb')].sort.each { |f| require f }
