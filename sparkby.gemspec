Gem::Specification.new do |s|
  s.name        = 'sparkby'
  s.version     = '0.1.0'
  s.date        = '2015-05-31'
  s.summary     = 'Ruby wrapper around the Particle cloud API'
  s.description = 'Ruby wrapper around the Particle cloud API'
  s.authors     = ['Karl Parkinson']
  s.email       = 'kparkins@ualberta.ca'
  s.homepage    = 'https://github.com/KarlParkinson/sparkby'
  s.license     = 'GPL'

  s.add_dependency             'httparty', '~> 0.13.3'

  s.add_development_dependency 'webmock',  '~> 1.20.4'
  s.add_development_dependency 'sinatra',  '~> 1.4.5'

  s.files      = Dir["lib/**/*.rb"]
  s.test_files = Dir["spec/**/*.rb"] + Dir["spec/**/*.json"]
end
