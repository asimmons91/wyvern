module WyvernScene
  module Helpers
    module Keyable
      def self.included(base)
        base.extend ClassMethods
      end

      # Identifier for the current object
      # @return [Symbol]
      def key
        self.class.name.split("::")[-1].underscore.to_sym
      end

      module ClassMethods
        # Identifier for the current object
        # @return [Symbol]
        def key
          name.split("::")[-1].underscore.to_sym
        end
      end
    end
  end
end
