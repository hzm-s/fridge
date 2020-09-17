# typed: false
require 'spec_helper'
$LOAD_PATH << File.expand_path('../domain', __dir__)

require 'shared'
require 'person'
require 'product'
require 'team'
require 'issue'
require 'release'

Dir[File.join(File.expand_path('./domain_support', __dir__), '**', '*.rb')].sort.each { |f| require f }
