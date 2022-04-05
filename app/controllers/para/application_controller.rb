module Para
  class ApplicationController < ActionController::Base
    prepend_around_action :switch_locale

    before_action :add_admin_home_breadcrumb

    def admin?
      true
    end

    private

    def add_admin_home_breadcrumb
      add_breadcrumb :home, admin_path
    end


    private

    def switch_locale(&action)
      current_locale = params[:locale].presence || I18n.default_locale
      I18n.with_locale(current_locale.to_sym, &action)
    end
  end
end
