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

describe 'Correct Login', js: true do

  subject { page }

  before do
    User.find_by_email('name@example.com').destroy unless User.find_by_email('name@example.com').nil?
    create(:user)
    visit login_path
    fill_in 'email', with: 'name@example.com'
    fill_in 'password', with: 'password'
    click_button 'login-button'
  end
  it { should_not have_selector '.error' }
end

describe 'Fully Incorrect Login', js: true do

  subject { page }

  before do
    User.find_by_email('name@example.com').destroy unless User.find_by_email('name@example.com').nil?
    create(:user)
    visit login_path
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
    visit login_path
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
    visit login_path
    fill_in 'email', with: 'name@example.com'
    fill_in 'password', with: 'invalidpass'
    click_button 'login-button'
  end
  it { should have_selector '.error' }
end

describe 'Register Page', js: true do

  subject { page }

  before do
    visit login_path
    click_link 'Register'
  end

  it { should have_selector '#register' }
  it { should have_selector 'h3', text: 'Register' }
  it { should have_field 'Name' }
  it { should have_field 'Email Address' }
  it { should have_field 'Confirm Email Address' }
  it { should have_field 'Password' }
  it { should have_field 'Confirm Password' }
  it { should have_button 'Submit' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_selector '#register'
  end

end

describe 'Valid Registration', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit login_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@example.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'password'
  end

  it { should have_selector '#register' }
  it 'should increment the user count' do
    expect do
      click_button 'Submit'
      sleep(1)
    end.to change(User, :count).by 1
  end

  it do
    click_button 'Submit'
    should_not have_selector('.error')
  end

  it do
    click_button 'Submit'
    should have_content 'Success'
  end

  it 'should close correctly' do
    click_button 'Close'
    should_not have_selector '#register'
  end

end

describe 'invalid_name', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit login_path
    click_link 'Register'
    fill_in 'Name', with: 'B'
    fill_in 'user_email', exact: true, with: "#{num}@example.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'password'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_selector '#register'
  end
end

describe 'invalid_email', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit login_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@example"
    fill_in 'Confirm Email Address', with: "#{num}@example"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'password'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_selector '#register'
  end
end

describe 'non_matching_email', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit login_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@exampel.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'password'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_selector '#register'
  end
end

describe 'invalid_password', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit login_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@example.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'pa'
    fill_in 'Confirm Password', with: 'pa'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_selector '#register'
  end
end

describe 'non_matching_password', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    visit login_path
    click_link 'Register'
    fill_in 'Name', with: 'Bob'
    fill_in 'user_email', exact: true, with: "#{num}@example.com"
    fill_in 'Confirm Email Address', with: "#{num}@example.com"
    fill_in 'user_password', exact: true, with: 'password'
    fill_in 'Confirm Password', with: 'passw0rd'
    @initial_count = User.count
    click_button 'Submit'
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_selector '#register'
  end

end
describe 'existing_email', js: true do

  subject { page }

  before :each do
    num = rand(100000)
    2.times do
      visit login_path
      click_link 'Register'
      fill_in 'Name', with: 'Bob'
      fill_in 'user_email', exact: true, with: "#{num}@example.com"
      fill_in 'Confirm Email Address', with: "#{num}@example.com"
      fill_in 'user_password', exact: true, with: 'password'
      fill_in 'Confirm Password', with: 'password'
      @initial_count = User.count
      click_button 'Submit'
      sleep(1)
    end
  end

  it { User.count.should eq @initial_count }
  it { should have_selector '.error' }
  it 'should close correctly' do
    click_button 'Close'
    should_not have_selector '#register'
  end
end