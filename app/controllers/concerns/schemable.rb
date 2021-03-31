module Schemable
    extend ActiveSupport::Concern

    class Error < StandardError
      def initialize(message)
        super(message)
      end
    end

    private

        def set_schema_dot_org(schema: {})
          raise Error.new("schema must be a hash") if schema.class != Hash
          raise Error.new("schema is required") if schema.empty?
          defaults = {
              :@context => "https://schema.org/"
          }
          @schema = defaults.merge!(schema).to_json.html_safe
        end
end
