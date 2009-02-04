# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def git_author(author_obj)
    mail_to(author_obj.email, author_obj.name,
            :class => 'git_author', :title => "email #{author_obj.name}")
  end
  
  def raw_path(af_record)
    "/#{af_record.class.name.tableize}/raw/#{af_record}"
  end
  
end
