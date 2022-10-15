class SiteConfig < ActiveRecord::Base
  def self.config(path)
    site_config = find_by(path:)
    value = site_config&.value
    value = false if ['', 'false'].include?(value)
    value
  end
end
