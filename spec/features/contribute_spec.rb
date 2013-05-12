require 'spec_helper'

describe 'Contribute Page' do

  before :each do
    visit contribute_path
  end

  it 'should have the title Nimbus | Contribute' do
    page.should have_title 'Nimbus | Contribute'
  end

  it 'should have navbar' do
    page.should have_selector 'nav'
  end

  it 'should have footer' do
    page.should have_selector 'footer'
  end
end
