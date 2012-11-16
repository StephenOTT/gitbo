require 'spec_helper'

describe "bounties/index" do
  before(:each) do
    assign(:bounties, [
      stub_model(Bounty,
        :user_id => 1,
        :issue_id => 2,
        :price => 3
      ),
      stub_model(Bounty,
        :user_id => 1,
        :issue_id => 2,
        :price => 3
      )
    ])
  end

  it "renders a list of bounties" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
