require 'spec_helper'

feature "User signs in" do
  scenario "with invaild email or password" do
    visit sign_in_path
    sign_in_with_invalid_information
    expect_error_messages_to_be_seen
  end

  scenario "with valid email and password" do
    janne = Fabricate(:user)
    sign_in(janne)
    expect_right_information_to_be_seen_in_the_plan_page(janne)
  end

  def sign_in_with_invalid_information
    fill_in :email,    with: "janne@twitter.com"
    fill_in :password, with: "123456"
    click_button '登录'
  end

  def expect_error_messages_to_be_seen
    expect(page).to have_content("Email或者密码不匹配，请重新输入")
    expect(page).not_to have_link("退出", sign_out_path)
  end

  def expect_right_information_to_be_seen_in_the_plan_page(a_user)
    expect(page).to have_content(a_user.full_name)
    expect(page).to have_link("退出", sign_out_path)
    expect(page).to have_content("体重")
  end
end