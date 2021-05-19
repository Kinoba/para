module Para
  module Admin
    class BaseController < Para::ApplicationController
      include Para::Admin::BaseHelper

      if Para.config.authenticate_admin_method
        before_action Para.config.authenticate_admin_method
      end

      before_action :authorize_admin_access

      layout 'para/admin'

      if respond_to?(:helper_method)
        helper_method :current_admin
        helper_method :admin_body_class
      end

      def current_admin
        @current_admin ||= if Para.config.current_admin_method
          send(Para.config.current_admin_method)
        end
      end

      def current_ability
        @current_ability ||= if (class_name = Para::Config.ability_class_name)
          class_name.constantize.new(current_admin)
        end
      end

      private

      def admin_body_class
        'admin'
      end

      # Override cancan controlelr resource class to avoid attributes
      # assignation issues with resources
      #
      def self.cancan_resource_class
        Para::ControllerResource
      end

      def authorize_admin_access
        authorize! :access, :admin
      end

      def self.load_and_authorize_component(options = {})
        before_action do
          load_and_authorize_component(options)
        end
      end

      def load_and_authorize_component(options = {})
        options.reverse_merge!(class:  'Para::Component::Base', find_by: :slug)

        loader = self.class.cancan_resource_class.new(self, :component, options)
        loader.load_and_authorize_resource

        ActiveDecorator::Decorator.instance.decorate(@component) if @component

        add_breadcrumb(@component.name, @component.path) if @component
      end
    end
  end
end
