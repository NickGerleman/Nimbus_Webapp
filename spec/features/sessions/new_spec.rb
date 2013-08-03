require 'spec_helper'

describe 'Login Page' do

  subject { page }

  before { visit new_session_path }

  it { should have_title 'Nimbus | Login' }
  it { should have_selector 'nav' }
  it { should have_selector 'footer' }
  it { should have_link 'Register' }
  it { should have_button 'Login' }
  it { should have_selector 'h2', text: 'Register Now' }
  it { should have_selector 'h3', text: 'Login' }
end

describe 'Correct Login', js: true do

  subject { page }

  before do
    User.find_by_email('name@example.com').destroy unless User.find_by_email('name@example.com').nil?
    create(:user)
    visit new_session_path
    fill_in 'email', with: 'name@example.com'
    fill_in 'password', with: 'password'
    click_button 'login-button'
    sleep 0.5
  end

  after { Session.last.destroy unless Session.last.nil? }

  it { should_not have_selector '.error' }
  it { should_not have_content 'Login' }
  it { should have_content 'Account' }

  it do
    visit edit_user_path
    should have_content 'Bob'
  end

  it do
    visit logout_path
    should have_content 'Login'
    should_not have_content 'Account'
  end
end

describe 'Fully Incorrect Login', js: true do

  subject { page }

  before do
    User.find_by_email('name@example.com').destroy unless User.find_by_email('name@example.com').nil?
    create(:user)
    visit new_session_path
    fill_in 'email', with: 'invalidcom@bla.n'
    fill_in 'password', with: 'invalidpass'
    click_button 'login-button'
  end
  it { should have_selector '.error' }
end

describe 'Incorrect Email', js: true do

  subject { page }

  before do
    User.find_by_email('name@example.com').destroy unless User.find_by_email('name@example.com').nil?
    create(:user)
    visit new_session_path
    fill_in 'email', with: 'invalidcom@bla.n'
    fill_in 'password', with: 'password'
    click_button 'login-button'
  end
  it { should have_selector '.error' }
end

describe 'Incorrect Password', js: true do

  subject { page }

  before do
    User.find_by_email('name@example.com').destroy unless User.find_by_email('name@example.com').nil?
    create(:user)
    visit new_session_path
    fill_in 'email', with: 'name@example.com'
    fill_in 'password', with: 'invalidpass'
    click_button 'login-button'
  end
  it { should have_selector '.error' }
end
