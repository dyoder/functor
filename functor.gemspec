Gem::Specification.new do |s|
  s.name = %q{functor}
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Yoder", "Matthew King", "Lawrence Pit"]
  s.date = %q{2008-10-08}
  s.email = %q{dan@zeraweb.com}
  s.files = ["doc/HISTORY", "doc/rdoc", "doc/rdoc/classes", "doc/rdoc/classes/Functor", "doc/rdoc/classes/Functor/Method.html", "doc/rdoc/classes/Functor/Method.src", "doc/rdoc/classes/Functor/Method.src/M000006.html", "doc/rdoc/classes/Functor.html", "doc/rdoc/classes/Functor.src", "doc/rdoc/classes/Functor.src/M000001.html", "doc/rdoc/classes/Functor.src/M000002.html", "doc/rdoc/classes/Functor.src/M000003.html", "doc/rdoc/classes/Functor.src/M000004.html", "doc/rdoc/classes/Functor.src/M000005.html", "doc/rdoc/classes/Object.html", "doc/rdoc/classes/Object.src", "doc/rdoc/classes/Object.src/M000007.html", "doc/rdoc/created.rid", "doc/rdoc/files", "doc/rdoc/files/doc", "doc/rdoc/files/doc/HISTORY.html", "doc/rdoc/files/doc/README.html", "doc/rdoc/files/lib", "doc/rdoc/files/lib/functor_rb.html", "doc/rdoc/files/lib/object_rb.html", "doc/rdoc/fr_class_index.html", "doc/rdoc/fr_file_index.html", "doc/rdoc/fr_method_index.html", "doc/rdoc/index.html", "doc/rdoc/rdoc-style.css", "doc/README", "lib/functor.rb", "lib/object.rb", "test/fib.rb", "test/functor.rb", "test/guards.rb", "test/helpers.rb", "test/inheritance.rb", "test/matchers.rb", "test/reopening.rb", "test/with_self.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://dev.zeraweb.com/}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.6")
  s.rubyforge_project = %q{functor}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Pattern-based dispatch for Ruby, inspired by Topher Cyll's multi.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
    else
    end
  else
  end
end
