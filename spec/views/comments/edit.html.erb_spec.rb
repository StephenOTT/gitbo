require 'spec_helper'

describe "comments/edit" do
  before(:each) do
    @comment = assign(:comment, stub_model(Comment,
      :body => "MyText",
      :git_number => 1,
      :owner_name => "MyString",
      :owner_image => "MyString",
      :issue_id => 1
    ))
  end

  it "renders the edit comment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => comments_path(@comment), :method => "post" do
      assert_select "textarea#comment_body", :name => "comment[body]"
      assert_select "input#comment_git_number", :name => "comment[git_number]"
      assert_select "input#comment_owner_name", :name => "comment[owner_name]"
      assert_select "input#comment_owner_image", :name => "comment[owner_image]"
      assert_select "input#comment_issue_id", :name => "comment[issue_id]"
    end
  end
end
