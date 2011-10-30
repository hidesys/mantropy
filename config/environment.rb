# Load the rails application
require File.expand_path('../application', __FILE__)

Mime::Type.register_alias("text/plane", :txt)

# Initialize the rails application
Mantropy::Application.initialize!
