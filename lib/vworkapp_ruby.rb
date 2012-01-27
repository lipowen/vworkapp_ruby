require 'httparty'
require 'active_support/core_ext/hash'
require 'active_model'

require 'vworkapp_ruby/base/attribute_methods'
require 'vworkapp_ruby/base/resource'
require 'vworkapp_ruby/base/response_error'

require 'vworkapp_ruby/location'
require 'vworkapp_ruby/step'
require 'vworkapp_ruby/contact'
require 'vworkapp_ruby/telemetry'
require 'vworkapp_ruby/custom_field'
require 'vworkapp_ruby/job'
require 'vworkapp_ruby/worker'
require 'vworkapp_ruby/customer'
# require 'vworkapp/proof_of_delivery'

require 'vworkapp_ruby/base/httparty_monkey_patch'

VW = VWorkApp