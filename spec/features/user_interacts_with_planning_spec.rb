require "spec_helper"

feature "User interacts with plan" do
  given(:janne) { Fabricate(:user) }

  context "user has not created today plan" do
    scenario "user creates today plan and records result" do
      sign_in(janne)
      expect_weight_is_empty
      expect_link_not_to_be_seen('增加项目')

      create_plan_with_weight(80)
      expect_link_to_be_seen('增加项目')
      expect_content_not_to_be_seen('项目名称')

      add_new_item
      expect_new_item_to_be_seen

      item = Item.find_by(name: '慢跑')

      update_item_with_invalid_duration(item)
      expect_error_message_be_seen

      update_item_be_finished(item)
      expect_checkbox_of_finished_item_be_checked_and_disabled
    end
  end
  
  context "user has created today plan" do
    given!(:today_plan) { Fabricate(:plan, user: janne, weight: 100) }
    given!(:item) { Fabricate(:item, plan: today_plan, name: "平板支撑", duration: 20, result: 20, unit: "分钟") }

    scenario "user edits plan and records result" do
      sign_in(janne)
      expect_weight_is(100)
      expect_item_info('item_duration', 20)

      update_weight(today_plan, 99)
      expect_weight_is(99)

      update_item_be_finished(item)
      expect_checkbox_of_finished_item_be_checked_and_disabled
    end
  end

  def expect_weight_is_empty
    expect(find_field('体重').value).to be_nil
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_link(link_text)
  end

  def expect_link_to_be_seen(link_text)
    expect(page).to have_link(link_text)
  end

  def create_plan_with_weight(weight)
    fill_in :plan_weight, with: weight
    click_button '保存'
  end

  def expect_content_not_to_be_seen(content_text)
    expect(page).not_to have_content(content_text)
  end

  def add_new_item
    click_link('增加项目')
    fill_in :item_name,     with: "慢跑"
    fill_in :item_duration, with: 60
    fill_in :item_result,   with: 7
    fill_in :item_unit,     with: "公里"
    click_button '新增'
  end

  def expect_new_item_to_be_seen
    expect(find_field('item_duration').value).to eq("60")
    expect(find_by_id('item_finished').value).to eq("1")
  end

  def update_item_with_invalid_duration(item)
    fill_in :item_duration, with: 0
    click_button "item_#{item.id}"
  end

  def expect_error_message_be_seen
    expect(find_by_id('flash_danger').text).not_to be_nil
  end

  def update_item_be_finished(item)
    check('item_finished')
    click_button "item_#{item.id}"
  end

  def expect_checkbox_of_finished_item_be_checked_and_disabled
    expect(find_by_id('item_finished').checked?).to eq('checked')
    expect(find_by_id("item_finished").disabled?).to eq("disabled")
  end

  def expect_item_info(info_id, info_value)
    expect(find_field(info_id).value).to eq("#{info_value}")
  end

  def update_weight(plan, weight)
    fill_in :plan_weight, with: weight
    click_button '保存'
    plan.reload
  end


  def expect_weight_is(weight)
    expect(find_field('体重').value).to eq(weight.to_s)
  end
end
