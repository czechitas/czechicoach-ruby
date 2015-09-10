require 'rails_helper'

RSpec.describe "coaches/edit", type: :view do
  before(:each) do
    @coach = assign(:coach, Coach.create!(
      :name => "MyString",
      :city => "MyString",
      :email => "MyString"
    ))
  end

  it "renders the edit coach form" do
    render

    assert_select "form[action=?][method=?]", coach_path(@coach), "post" do

      assert_select "input#coach_name[name=?]", "coach[name]"

      assert_select "input#coach_city[name=?]", "coach[city]"

      assert_select "input#coach_email[name=?]", "coach[email]"
    end
  end
end
