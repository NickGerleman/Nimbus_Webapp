require 'spec_helper'

describe 'Login Page' do

  subject { page }

  before { visit login_path }

  it { should have_title 'Nimbus | Login' }
  it { should have_selector 'nav' }
  it { should have_selector 'footer' }
  it { should have_link 'Register' }
  it { should have_button 'Login' }
  it { should have_selector 'h2', text: 'Register Now' }
  it { should have_selector 'h3', text: 'Login' }
end

describe 'Register', js: true do

  subject { page }

  before do
    visit login_path
    click_link 'Register'
  end

  it { should have_selector 'h3', text: 'Register' }
  it { should have_field 'Name' }
  it { should have_field 'Email Address' }
  it { should have_field 'Confirm Email Address' }
  it { should have_field 'Password' }
  it { should have_field 'Confirm Password' }

end
