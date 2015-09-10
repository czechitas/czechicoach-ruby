require 'rails_helper'

RSpec.describe "coaches/new", type: :view do
  before(:each) do
    assign(:coach, Coach.new(
      :name => "MyString",
      :city => "MyString",
      :email => "MyString"
    ))
  end

  it "renders new coach form" do
    render

    assert_select "form[action=?][method=?]", coaches_path, "post" do

      assert_select "input#coach_name[name=?]", "coach[name]"

      assert_select "input#coach_city[name=?]", "coach[city]"

      assert_select "input#coach_email[name=?]", "coach[email]"
    end
  end
end
