require 'json'
require 'forwardable'
require 'active_support/core_ext/string'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/hash/conversions' # to_xml
require 'active_support/concern'
require 'active_support/time'

require 'dry-types'
require 'graphiti_errors'

require 'jsonapi/serializable'

require "graphiti/version"
require "graphiti/jsonapi_serializable_ext"
require "graphiti/configuration"
require "graphiti/context"
require "graphiti/errors"
require "graphiti/types"
require "graphiti/schema"
require "graphiti/schema_diff"
require "graphiti/adapters/abstract"
require "graphiti/resource/sideloading"
require "graphiti/resource/links"
require "graphiti/resource/configuration"
require "graphiti/resource/dsl"
require "graphiti/resource/interface"
require "graphiti/resource/polymorphism"
require "graphiti/sideload"
require "graphiti/sideload/has_many"
require "graphiti/sideload/belongs_to"
require "graphiti/sideload/has_one"
require "graphiti/sideload/many_to_many"
require "graphiti/sideload/polymorphic_belongs_to"
require "graphiti/resource"
require "graphiti/resource_proxy"
require "graphiti/query"
require "graphiti/scope"
require "graphiti/deserializer"
require "graphiti/renderer"
require "graphiti/hash_renderer"
require "graphiti/filter_operators"
require "graphiti/scoping/base"
require "graphiti/scoping/sort"
require "graphiti/scoping/paginate"
require "graphiti/scoping/extra_attributes"
require "graphiti/scoping/filterable"
require "graphiti/scoping/default_filter"
require "graphiti/scoping/filter"
require "graphiti/stats/dsl"
require "graphiti/stats/payload"
require "graphiti/util/include_params"
require "graphiti/util/field_params"
require "graphiti/util/hash"
require "graphiti/util/relationship_payload"
require "graphiti/util/persistence"
require "graphiti/util/validation_response"
require "graphiti/util/sideload"
require "graphiti/util/hooks"
require "graphiti/util/attribute_check"
require "graphiti/util/serializer_attributes"
require "graphiti/util/serializer_relationships"
require "graphiti/util/class"
require "graphiti/util/link"
require 'graphiti/adapters/null'
require "graphiti/extensions/extra_attribute"
require "graphiti/extensions/boolean_attribute"
require "graphiti/extensions/temp_id"
require "graphiti/serializer"

if defined?(ActiveRecord)
  require 'graphiti/adapters/active_record'
end

if defined?(Rails)
  require 'graphiti/railtie'
  require 'graphiti/rails'
  require 'graphiti/responders'
end

module Graphiti
  autoload :Base, 'graphiti/base'

  def self.included(klass)
    klass.instance_eval do
      include Base
    end
  end

  # @api private
  def self.context
    Thread.current[:context] ||= {}
  end

  # @api private
  def self.context=(val)
    Thread.current[:context] = val
  end

  # @api private
  def self.with_context(obj, namespace = nil)
    begin
      prior = self.context
      self.context = { object: obj, namespace: namespace }
      yield
    ensure
      self.context = prior
    end
  end

  def self.config
    @config ||= Configuration.new
  end

  # @example
  #   Graphiti.configure do |c|
  #     c.raise_on_missing_sideload = false
  #   end
  #
  # @see Configuration
  def self.configure
    yield config
  end

  def self.resources
    @resources ||= []
  end
end

require "graphiti/runner"