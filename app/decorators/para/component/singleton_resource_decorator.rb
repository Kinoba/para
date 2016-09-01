module Para
  module Component
    module SingletonResourceDecorator
      include Para::Component::BaseDecorator

      def path(options = {})
        find_path([:admin, self], options)
      end

      def relation_path(controller_or_resource, *nested_resources, **options)
        nested = nested_resources.any?

        if Hash === controller_or_resource
          options = controller_or_resource
        end

        options[:action] = action_option_for(options, nested: nested)
        data = [:admin, self, *nested_resources]

        polymorphic_path(data, options)
      end

      def action_option_for(options, nested: false)
        if !nested && options[:action].try(:to_sym) == :show
          nil
        else
          options[:action]
        end
      end
    end
  end
end
