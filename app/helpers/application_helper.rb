# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include ActiveFileHelper
  
  def git_author(author_obj)
    mail_to(author_obj.email, author_obj.name,
            :class => 'git_author', :title => "email #{author_obj.name}")
  end
  
  def pages_from_grep(repo, results)
    results.map do |treeish, matches|
      [(treeish.match("^(.+):(.+)$") ? page = Page.find(File.join(repo.path, $2)) : nil),
       (treeish.match("^(.+):(.+)$") ? $1 : nil),
       matches]
    end.select{|page, sha, matches| page}.compact
  end

  # overwrite the default af_path so that it doesn't use controllers
  alias :af_path_orig :af_path
  def af_path(action, af, options = {})
    options = {:controller => nil}.merge(options)
    af_path_orig(action, af, options)
  end

  # for git commits
  def user_to_git_author
    user = current_user
    "#{user.name.size > 0 ? user.name : user.login} <#{user.email}>"
  end
  
end
