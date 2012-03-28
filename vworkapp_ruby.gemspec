Gem::Specification.new do |s|
  s.name        = "vworkapp_ruby"
  s.version     = "0.7.3"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["vWorkApp Inc.", "Aish Fenton"]
  s.email       = ["info@vworkapp.com"]
  s.homepage    = "http://api.vworkapp.com"
  s.summary     = %q{A ruby wrapper for vWorkApp's API}
  s.description = %q{A ruby wrapper for vWorkApp's API}

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency "activemodel"
  s.add_dependency "httparty"
  s.add_dependency "gcoder"

  s.add_development_dependency "rspec"

  s.files              = `git ls-files`.split("\n") rescue ''
  s.test_files         = `git ls-files -- {test, spec, features}/*`.split("\n")

  s.require_paths      = ["lib"]
end
