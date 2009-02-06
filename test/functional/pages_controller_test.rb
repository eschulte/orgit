require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  
  def test_commit_diff
    get(raw_path(Page.first))
    assert_assigns(:page)
  end
  
end
