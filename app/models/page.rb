class Page < ActiveRecord::Base
  self.base_directory = File.join(RAILS_ROOT, "wikis")
  self.location = [:wiki_name, "**", :name, "org"]
  has_one :wiki, :from => :wiki_name, :to => :name
  
end
