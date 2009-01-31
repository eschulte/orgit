class Page < ActiveFile::Base
  self.base_directory = File.join(RAILS_ROOT, "repos")
  self.location = [:repo_name, "**", :name, "org"]
  has_one :repo, :from => :repo_name, :to => :name
  
  acts_as_org
  
  acts_as_git
  
end
