Dir[Rails.root.join('lib/*.rb')].each do |file|
  require file
end
