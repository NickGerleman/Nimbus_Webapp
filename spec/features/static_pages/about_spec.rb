require 'spec_helper'

describe 'About Page' do

  subject { page }

  before { visit about_path }

  it { should have_title 'Nimbus | About Us' }
  it { should have_selector 'nav' }
  it { should have_selector 'footer' }

end
