# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def git_author(author_obj)
    mail_to(author_obj.email, author_obj.name,
            :class => 'git_author', :title => "email #{author_obj.name}")
  end
  
  def raw_path(af_record)
    af_record.to_s
  end
  
  def show_path(af_record)
    "/#{af_record.class.name.tableize}/raw/#{af_record}"
  end
  
  def path_from_params(params)
    if params[:rest]
      params[:rest].join("/")
    else
      params[:id]
    end
  end
  
  def pages_from_grep(repo, results)
    results.map do|treeish, matches|
      [(treeish.match("^(.+):(.+)$") ? page = Page.find(File.join(repo.path, $2)) : nil), matches]
    end.select{|page, matches| page}.compact
  end
end
