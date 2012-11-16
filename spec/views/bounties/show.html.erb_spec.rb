require 'spec_helper'

describe "bounties/show" do
  before(:each) do
    @bounty = assign(:bounty, stub_model(Bounty,
      :user_id => 1,
      :issue_id => 2,
      :price => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
  end
end
