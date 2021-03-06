require 'spec_helper'

describe 'checkouts/show' do
  fixtures :checkouts, :users, :user_has_roles, :roles, :items

  before(:each) do
    @checkout = assign(:checkout, stub_model(Checkout,
                                             user_id: 2,
                                             item_id: items(:item_00001).id))
    view.stub(:current_user).and_return(User.find_by(username: 'enjuadmin'))
  end

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Due date/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Item identifier/)
  end
end
