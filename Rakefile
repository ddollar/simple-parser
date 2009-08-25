require 'rubygems'
require 'erb'
require 'yaml'
require 'rake'
require 'rake/rdoctask'
require 'spec/rake/spectask'
require 'spec/rake/verify_rcov'
require 'FileUtils'
require 'BlueCloth'

task :default => [ 'rspec:run' ]

namespace :gem do

  task :customize do
    raise 'GEM required' unless name = ENV['GEM']
    raise 'CONST required' unless const = ENV['CONST']

    raise 'already configured' unless File.exists?('lib/generic')

    lib = File.open('lib/generic.rb', 'r') { |f| f.read.gsub('Generic', const) }
    File.open('lib/generic.rb', 'w') { |f| f.puts lib }

    FileUtils.mv('lib/generic',    "lib/#{name}")
    FileUtils.mv('lib/generic.rb', "lib/#{name}.rb")

    editor = ENV['EDITOR'] || 'vi'
    system "#{editor} config/gem.rb"
  end

  task :config do
    @config = OpenStruct.new

    File.open("config/gem.rb", "r") do |gem_config|
      eval(gem_config.read)
    end

    @config.files = FileList["{bin,doc,lib,test}/**/*"].to_a.map do |file|
      '"' + file + '"'
    end.join(',')
  end

  desc "Build the gem"
  task :build => [ 'gem:config', 'gem:spec:build' ] do
    spec = nil
    File.open("#{@config.name}.gemspec", 'r') do |gemspec|
      eval gemspec.read
    end
    gemfile = Gem::Builder.new(spec).build
    Dir.mkdir('pkg') unless File.exists?('pkg')
    File.rename(gemfile, "pkg/#{gemfile}")
  end

  namespace :spec do

    desc "Build gemspec"
    task :build => [ :config ] do
      File.open("config/gemspec.rb.erb", "r") do |template|
        File.open("#{@config.name}.gemspec", "w") do |gemspec|
          template_data =  "<% config = YAML::load(%{#{Regexp.escape(YAML::dump(@config))}}) %>\n"
          template_data += template.read
          original_stdout = $stdout
          $stdout = gemspec
          ERB.new(template_data).run
          $stdout = original_stdout
        end
      end
    end

    desc "Test gemspec against Github"
    task :test => [ 'gem:config', :build ] do
      require 'rubygems/specification'
      data = File.read("#{@config.name}.gemspec")
      spec = nil
      Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
      puts spec
    end

  end
end

namespace :documentation do

  desc 'Compile HTML documentation from Markdown'
  task :compile do
    Dir['**/*.markdown'].each do |file|
      html_file = file.gsub('.markdown', '.html')
      html = File.open(file, 'r') { |f| BlueCloth.new(f.read).to_html }
      File.open(html_file, 'w') { |f| f.puts html }
    end
  end

end

namespace :rdoc do

  desc 'Generate RDoc'
  rd = Rake::RDocTask.new(:build) do |rdoc|
    Rake::Task['gem:config'].invoke
    Rake::Task['documentation:compile'].invoke
    rdoc.title = @config.name
    rdoc.main  = 'README.html'
    rdoc.rdoc_dir = 'output/rdoc'
    rdoc.options << '--line-numbers' << '--inline-source'
    rdoc.rdoc_files.include('README.html', 'lib/**/*.rb')
  end

  desc 'View RDoc'
  task :view => [ :build ] do
    system %{open output/rdoc/index.html}
  end

end

namespace :rspec do

  desc "Run rspec tasks"
  Spec::Rake::SpecTask.new(:run) do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    #t.spec_opts = ['--options', 'spec/spec.opts']
    unless ENV['NO_RCOV']
      t.rcov = true
      t.rcov_dir = 'output/coverage'
      t.rcov_opts = ['--exclude', 'bin\/rtr,examples,\/var\/lib\/gems,\/Library\/Ruby,\.autotest']
    end
  end

  desc "Show code coverage"
  task :coverage => [ :run ] do
    system %{open output/coverage/index.html}
  end

  desc "Verify code coverage"
  RCov::VerifyTask.new(:verify => :run) do |t|
    t.threshold = 100.0
    t.index_html = 'output/coverage/index.html'
  end

end
