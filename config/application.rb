require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module ManyoKadai
  class Application < Rails::Application
    config.i18n.available_locales = [:en, :ja]
    config.i18n.default_locale = :ja
    # config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.yml').to_s]
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.generators do |g|
      g.test_framework :rspec,
                      model_specs: true,
                      view_specs: false,
                      helper_specs: false,
                      routing_specs: false,
                      controller_specs: false,
                      request_specs: false
    end
  end
end