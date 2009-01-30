class Wiki < ActiveRecord::Base
  self.base_directory = File.join(RAILS_ROOT, "wikis")
  self.location = [:name, "/"]
  has_many :pages, :from => :name, :to => :wiki_name

end
