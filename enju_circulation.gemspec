$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enju_circulation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enju_circulation"
  s.version     = EnjuCirculation::VERSION
  s.authors     = ["Kosuke Tanabe"]
  s.email       = ["tanabe@mwr.mediacom.keio.ac.jp"]
  s.homepage    = "https://github.com/next-l/enju_circulation"
  s.summary     = "enju_circulation plugin"
  s.description = "Circulation management for Next-L Enju"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2"
  s.add_dependency "simple_form"
  s.add_dependency "validates_timeliness"
  s.add_dependency "inherited_resources"
  s.add_dependency "state_machine"
  s.add_dependency "enju_message", "~> 0.1.14.pre"
  s.add_dependency "enju_event", "~> 0.1.17.pre5"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "sunspot_solr", "~> 2.0.0.pre.130115"
  s.add_development_dependency "enju_biblio", "~> 0.1.0.pre18"
  s.add_development_dependency "enju_library", "~> 0.1.0.pre9"
  s.add_development_dependency "enju_export", "~> 0.1.1.pre"
  s.add_development_dependency "mobylette"
  s.add_development_dependency "simplecov"
end
