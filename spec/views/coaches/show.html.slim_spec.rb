require 'rails_helper'

RSpec.describe "coaches/show", type: :view do
  before(:each) do
    @coach = assign(:coach, Coach.create!(
      :name => "Name",
      :city => "City",
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Email/)
  end
end
