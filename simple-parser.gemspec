
spec = Gem::Specification.new do |s|
  
  s.name     = "simple-parser"
  s.version  = "0.1.1"
  s.summary  = "Simple parser"
  s.homepage = "http://peervoice.com/software/simple-parser"
  
  s.author   = "David Dollar"
  s.email    = "ddollar@gmail.com"
  
  s.files    = ["lib/simple-parser","lib/simple-parser/string.rb","lib/simple-parser.rb"]
  s.platform = Gem::Platform::RUBY
                   
  s.rubyforge_project = "simple-parser"
  s.require_path      = "lib"
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README.html"]
  
end
