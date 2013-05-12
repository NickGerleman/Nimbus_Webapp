require 'spec_helper'

describe 'Login Page' do

  before :each do
    visit login_path
  end

  it 'should have the title Nimbus | Login' do
    page.should have_title 'Nimbus | Login'
  end

  it 'should have navbar' do
    page.should have_selector 'nav'
  end

  it 'should have footer' do
    page.should have_selector 'footer'
  end

  it 'should have register button' do
    page.should have_link 'register-button'
  end
end
