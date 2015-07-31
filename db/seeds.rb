# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


sites = [
  { name: 'District Office', code: 5, abbr: 'do' },
  { name: 'Maintenance', code: 6, abbr: 'mo' },
  { name: 'Cedarcreek School', code: 10, abbr: 'cc' },
  { name: 'Emblem School', code: 15, abbr: 'em' },
  { name: 'Highlands School', code: 20, abbr: 'hi' },
  { name: 'Mountainview School', code: 25, abbr: 'mv' },
  { name: 'Rio Vista School', code: 30, abbr: 'rv' },
  { name: 'Rosedell School', code: 35, abbr: 'ro' },
  { name: 'Santa Clarita School', code: 40, abbr: 'sc' },
  { name: 'Charles Helmers School', code: 45, abbr: 'he' },
  { name: 'Skyblue Mesa School', code: 50, abbr: 'sk' },
  { name: 'James Foster School', code: 55, abbr: 'fo' },
  { name: 'Bouquet Canyon School', code: 60, abbr: 'bo' },
  { name: 'Plum Canyon School', code: 65, abbr: 'pc' },
  { name: 'North Park School', code: 70, abbr: 'np' },
  { name: 'Bridgeport School', code: 75, abbr: 'bp' },
  { name: 'Tesoro Del Valle School', code: 80, abbr: 'tv' },
  { name: 'West Creek Academy', code: 85, abbr: 'wc' }
  ]

sites.each do |site|
  Site.where(code: site[:code]).first_or_create(site)
end

roles = [
  { name: 'admin' },
  { name: 'office' },
  { name: 'warehouse' },
  { name: 'finance' }
]

roles.each do |role|
  Role.where(name: role[:name]).first_or_create
end
