class Repo < ActiveFile::Base
  self.base_directory = File.join(RAILS_ROOT, "repos")
  self.location = [:name, "/"]
  has_many :pages, :from => :name, :to => :repo_name
  include ActiveFile::Acts::Git
  
  
end
