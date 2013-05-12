require 'spec_helper'

describe 'Features Page' do

  before :each do
    visit features_path
  end

  it 'should have the title Nimbus | Features' do
    page.should have_title 'Nimbus | Features'
  end

  it 'should have navbar' do
    page.should have_selector 'nav'
  end

  it 'should have footer' do
    page.should have_selector 'footer'
  end
end
