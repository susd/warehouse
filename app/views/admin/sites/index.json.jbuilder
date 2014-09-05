json.array!(@sites) do |site|
  json.extract! site, :id, :name, :code, :abbr
  json.url site_url(site, format: :json)
end
