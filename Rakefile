require 'rake'
require 'rake/clean'
require 'spec/rake/spectask'

 
desc "Run all specs in spec directory"
Spec::Rake::SpecTask.new(:spec)
 
namespace :spec do
  desc "Run all specs in spec directory with RCov"
  Spec::Rake::SpecTask.new(:rcov) do |t|
    t.rcov = true
  end
end
