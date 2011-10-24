# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "colorific/version"

Gem::Specification.new do |s|
  s.name        = "colorific"
  s.version     = Colorific::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Carlos Brando"]
  s.email       = ["eduardobrando@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Run your tests (Minitest) with lots of color!}
  s.description = %q{Run your tests (Minitest) with lots of color!}

  s.rubyforge_project = "colorific"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "minitest", "~> 2.3"
  s.add_dependency "ruby-progressbar", "~> 0.0.10"
end
