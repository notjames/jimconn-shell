# -*- encoding: utf-8 -*-
# stub: soda-ruby 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "soda-ruby".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris Metcalf".freeze, "Dominic Cicilio".freeze]
  s.date = "2019-01-08"
  s.description = "A simple wrapper for SODA 2.0. Includes an OmniAuth provider for OAuth 2.0".freeze
  s.email = "dominic.cicilio@tylertech.com".freeze
  s.homepage = "http://github.com/socrata/soda-ruby".freeze
  s.rubyforge_project = "soda-ruby".freeze
  s.rubygems_version = "2.7.6.2".freeze
  s.summary = "Ruby for SODA 2.0".freeze

  s.installed_by_version = "2.7.6.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hashie>.freeze, ["~> 3.5"])
      s.add_runtime_dependency(%q<multipart-post>.freeze, ["~> 2.0.0"])
      s.add_runtime_dependency(%q<sys-uname>.freeze, ["~> 1.0.2"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_development_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_development_dependency(%q<test-unit>.freeze, [">= 0"])
      s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    else
      s.add_dependency(%q<hashie>.freeze, ["~> 3.5"])
      s.add_dependency(%q<multipart-post>.freeze, ["~> 2.0.0"])
      s.add_dependency(%q<sys-uname>.freeze, ["~> 1.0.2"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_dependency(%q<webmock>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, [">= 0"])
      s.add_dependency(%q<test-unit>.freeze, [">= 0"])
      s.add_dependency(%q<rubocop>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<hashie>.freeze, ["~> 3.5"])
    s.add_dependency(%q<multipart-post>.freeze, ["~> 2.0.0"])
    s.add_dependency(%q<sys-uname>.freeze, ["~> 1.0.2"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda>.freeze, [">= 0"])
    s.add_dependency(%q<webmock>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<test-unit>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
  end
end
