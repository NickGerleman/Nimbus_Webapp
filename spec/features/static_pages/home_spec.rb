require 'spec_helper'

describe 'Home Page' do

  subject { page }

  before { visit root_path }

  it { should have_title 'Nimbus' }
  it { should have_selector 'nav' }
  it { should have_selector 'footer' }
  it { should have_selector 'h1', text: 'Welcome to Nimbus' }

end
