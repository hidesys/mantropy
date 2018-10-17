class SiteConfig < ActiveRecord::Base
  def self.config(path)
    site_config = find_by_path(path)
    value = site_config && site_config.value
    if value == '' || value == 'false'
      value = false
    end
    value
  end
end
