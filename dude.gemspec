lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dude/version"

Gem::Specification.new do |spec|
  spec.name          = "dude-cli"
  spec.version       = Dude::VERSION
  spec.authors       = ["Nikita Pupko"]
  spec.email         = ["lazynick7@gmail.com"]
  spec.summary       = %q{Daily assistant}
  spec.description   = %q{A daily assistant in the hard work of a programmer}
  spec.homepage      = "https://github.com/Random4405/dude"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = ["dude"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "byebug", "~> 9.1"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency "thor", "~> 0.20"
  spec.add_runtime_dependency "colorize", "~> 0.8"
  spec.add_runtime_dependency "gitlab", "~> 4.2"
  spec.add_runtime_dependency "git", "~> 1.3"
  spec.add_runtime_dependency "rest-client", "~> 2.0"
end
