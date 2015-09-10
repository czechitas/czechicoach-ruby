require 'rails_helper'

RSpec.describe "coaches/index", type: :view do
  before(:each) do
    assign(:coaches, [
      Coach.create!(
        :name => "Name",
        :city => "City",
        :email => "Email"
      ),
      Coach.create!(
        :name => "Name",
        :city => "City",
        :email => "Email"
      )
    ])
  end

  it "renders a list of coaches" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
