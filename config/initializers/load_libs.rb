Rails.root.glob('lib/*.rb').each do |file|
  require file
end
