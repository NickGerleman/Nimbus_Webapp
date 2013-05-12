require 'spec_helper'

describe 'About Page' do

  before :each do
    visit about_path
  end

  it 'should have the title Nimbus | About Us' do
    page.should have_title 'Nimbus | About Us'
  end

  it 'should have navbar' do
    page.should have_selector 'nav'
  end

  it 'should have footer' do
    page.should have_selector 'footer'
  end
end
