require 'spec_helper'

describe "comments/index" do
  before(:each) do
    assign(:comments, [
      stub_model(Comment,
        :body => "MyText",
        :git_number => 1,
        :owner_name => "Owner Name",
        :owner_image => "Owner Image",
        :issue_id => 2
      ),
      stub_model(Comment,
        :body => "MyText",
        :git_number => 1,
        :owner_name => "Owner Name",
        :owner_image => "Owner Image",
        :issue_id => 2
      )
    ])
  end

  it "renders a list of comments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Owner Name".to_s, :count => 2
    assert_select "tr>td", :text => "Owner Image".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
