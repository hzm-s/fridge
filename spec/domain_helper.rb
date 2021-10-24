# typed: false
require 'spec_helper'
$LOAD_PATH << File.expand_path('../domain', __dir__)

require 'shared'
require 'activity'
require 'person'
require 'product'
require 'plan'
require 'team'
require 'pbi'
require 'issue'
require 'sprint'
require 'work'

Dir[File.join(File.expand_path('./domain_support', __dir__), '**', '*.rb')].sort.each { |f| require f }
