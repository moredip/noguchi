require 'rake'
require 'rake/clean'
gem 'rspec', '~> 1' # rather than rspec 2
require 'spec/rake/spectask'

 
desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec)
 
namespace :spec do
  desc "Run all specs in spec directory with RCov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.rcov = true
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name        = "noguchi"
    gemspec.authors     = ["Pete Hodgson"]
    gemspec.email       = "public@thepete.net"
    gemspec.homepage    = "http://github.com/moredip/noguchi"
    gemspec.summary     = "A simple, declarative way to display tabular data"
    gemspec.description = "A simple, declarative way to display tabular data"

    gemspec.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.markdown)

    gemspec.add_dependency "builder"
    gemspec.add_development_dependency "rspec"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
