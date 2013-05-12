require 'spec_helper'

describe 'Home Page' do

  before :each do
    visit root_path
  end

  it 'should have the title Nimbus' do
    page.should have_title 'Nimbus'
  end

  it 'should have the heading "Welcome to Nimbus"' do
    page.should have_selector 'h1', text: 'Welcome to Nimbus'
  end

  it 'should have navbar' do
    page.should have_selector 'nav'
  end

  it 'should have footer' do
    page.should have_selector 'footer'
  end
end
