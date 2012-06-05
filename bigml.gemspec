require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "bigml"
  s.version = BigMLGem::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Francisco Martín", "Mercè Martín"]
  s.email = ["mmartin@atinet.es"]
  s.homepage = "https://github.com/mmerce/bigml_ruby"
  s.summary = "BigML api"
  s.description = "Ruby api for BigML objects' access"

  s.required_rubygems_version = ">= 1.3.6"

  # lol - required for validation
  s.rubyforge_project = "bigml"

  # If you have other dependencies, add them here
  # s.add_dependency "another", "~> 1.2"
  s.add_dependency "json", "~> 1.7.3"
  s.add_dependency "rest-client", "~> 1.6.7"


  # If you need to check in files that aren't .rb files, add them here
  s.files = Dir["{lib}/**/*.rb"]
  s.require_path = 'lib'

  # If you need an executable, add it here
  # s.executables = [""]

  # If you have C extensions, uncomment this line
  # s.extensions = "ext/extconf.rb"
end
