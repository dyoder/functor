Gem::Specification.new do |s|
  s.name = %q{functor}
  s.version = "0.2"

  s.specification_version = 2 if s.respond_to? :specification_version=

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder"]
  s.date = %q{2008-06-09}
  s.email = %q{dan@zeraweb.com}
  s.files = ["doc/HISTORY", "doc/README", "lib/functor.rb", "lib/object.rb", "test/fib.rb", "test/functor.rb", "test/helpers.rb", "test/inheritance.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://dev.zeraweb.com/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{funkytor}
  s.rubygems_version = %q{1.0.1}
  s.summary = %q{Pattern-based dispatch for Ruby, inspired by Topher Cyll's multi.}
end
