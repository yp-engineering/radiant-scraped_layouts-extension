# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-scraped_layouts-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-scraped_layouts-extension"
  s.version     = RadiantScrapedLayoutsExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantScrapedLayoutsExtension::AUTHORS
  s.email       = RadiantScrapedLayoutsExtension::EMAIL
  s.homepage    = RadiantScrapedLayoutsExtension::URL
  s.summary     = RadiantScrapedLayoutsExtension::SUMMARY
  s.description = RadiantScrapedLayoutsExtension::DESCRIPTION

  s.add_dependency "radiant", "~> 1.1.0"

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  s.require_paths = ["lib"]
end
