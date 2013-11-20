require 'casclient/frameworks/rails/filter'

class Cas
  cattr_accessor :test_mode
  cattr_accessor :cas_settings
  self.test_mode = Rails.env.test?

  class << self
    def enabled?
      return false if test_mode
      enabled
    end

    def load_config
      self.cas_settings = YAML::load_file(Rails.root.join('config', 'cas.defaults.yml'))
      CASClient::Frameworks::Rails::Filter.configure(
        :cas_base_url => cas_settings['base_url'],
        :http_proxy => cas_settings['http_proxy']
      )
    end
  end
end

if defined?(Rails::Railtie)
  class Cas::Railtie < Rails::Railtie
    config.after_initialize do
      Cas.load_config
    end
  end
else
  Cas.load_config
end
