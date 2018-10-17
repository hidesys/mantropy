class SiteConfig < ActiveRecord::Base
  def self.config(name)
    site_config = self.find_by_name(name)
    value = site_config && site_config.value
    if value == '' || value == 'false'
      value = false
    end
    value
  end
end
