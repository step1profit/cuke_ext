# encoding: utf-8

$:.push File.expand_path("../lib", __FILE__)
require "cuke_ext/version"

Gem::Specification.new do |gem|
  gem.name    = "cuke_ext"
  gem.version = CukeExt::VERSION

  gem.authors     = ["SoAwesomeMan","Step1Profit"]
  gem.email       = ["sales@step1profit.com"]
  gem.summary     = "Custom steps for JSON in Cucumber"
  gem.description = gem.summary
  gem.homepage    = "https://github.com/step1profit/cuke_ext"

  gem.add_development_dependency "rake", "~> 0.9"

  gem.add_dependency 'cucumber-rails'
  gem.add_dependency  "json_spec"
  gem.add_dependency  "akephalos2"
  gem.add_dependency  'database_cleaner'
  gem.add_dependency  'capybara'
  gem.add_dependency  "ZenTest"
  #gem.add_dependency "rspec-rails"
  #gem.add_dependency "rspec", "~> 2.0"
  #gem.add_dependency "cucumber", "~> 1.1", ">= 1.1.1"

  gem.files         = `git ls-files`.split($\)
  gem.test_files    = gem.files.grep(/^(spec|features)\//)
  gem.require_paths = ["lib"]
end
