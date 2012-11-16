require 'spec_helper'

describe "bounties/edit" do
  before(:each) do
    @bounty = assign(:bounty, stub_model(Bounty,
      :user_id => 1,
      :issue_id => 1,
      :price => 1
    ))
  end

  it "renders the edit bounty form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => bounties_path(@bounty), :method => "post" do
      assert_select "input#bounty_user_id", :name => "bounty[user_id]"
      assert_select "input#bounty_issue_id", :name => "bounty[issue_id]"
      assert_select "input#bounty_price", :name => "bounty[price]"
    end
  end
end
