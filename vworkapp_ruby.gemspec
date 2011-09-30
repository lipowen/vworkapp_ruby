
Gem::Specification.new do |s|
  s.name        = "vworkapp_ruby"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["vWorkApp", "Aish Fenton"]
  s.email       = ["info@vworkapp.com"]
  s.homepage    = "http://api.vworkapp.com/api/"
  s.description = %q{Simple interface to vWorkApp's api}
  s.description = %q{Simple interface to vWorkApp's api}

  s.required_rubygems_version = ">= 1.3.6"

  s.add_development_dependency "rspec"

  s.files              = `git ls-files`.split("\n") rescue ''
  s.test_files         = `git ls-files -- {test, spec, features}/*`.split("\n")

  s.require_paths      = ["lib"]

end
