Gem::Specification.new do |s|

  s.name            = 'torquay'
  s.version         = '0.0.3'
  s.licenses        = ['apache-2.0']
  s.summary         = "Wrapper utility functions around Docker image creation and maintenance"
  s.description     = "Utility class for managing Docker containers and images, wrapping docker-api"
  s.authors         = ["Tal Levy"]
  s.email           = 'tal@elastic.co'
  s.homepage        = 'https://github.com/talevy/docker-doctor'
  s.files           = ["lib/torquay.rb"]

  # Gem dependencies
  s.add_runtime_dependency 'docker-api', '~> 1.21'
end
