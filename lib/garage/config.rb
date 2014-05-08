require 'garage/docs/config'

module Garage
  def self.configure(&block)
    @config = Config::Builder.new(&block).build
  end

  def self.configuration
    @config
  end

  class Config
    attr_accessor :auth_center_host, :auth_center_url, :enable_auth_center
    attr_writer :cast_resource, :docs

    def initialize
      @enable_auth_center = true
    end

    def docs
      @docs ||= Docs::Config.new
    end

    def cast_resource
      @cast_resource ||= proc { |resource|
        if resource.respond_to?(:map)
          resource.map(&:to_resource)
        else
          resource.to_resource
        end
      }
    end

    class Builder
      def initialize(&block)
        @config = Config.new
        instance_eval(&block)
      end

      def build
        @config
      end

      def cast_resource(&block)
        @config.cast_resource = block
      end

      def docs
        @docs_builder ||= Docs::Config::Builder.new(@config.docs)
      end
    end
  end
end
