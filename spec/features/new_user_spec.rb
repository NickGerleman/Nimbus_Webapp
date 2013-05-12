require 'spec_helper'

describe 'New User Page' do

  before :each do
    visit new_users_path
  end

  it 'should not have navbar' do
    page.should_not have_selector 'nav'
  end

end
