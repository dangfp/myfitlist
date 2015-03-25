shared_examples "require_signed_in" do
  it "redirects to the sign in page" do
    action
    expect(response).to redirect_to(sign_in_path)
  end
end

shared_examples "show_new_plan" do
  it "redirects to the new plan page when the user doesn't create the plan of today" do
    action
    expect(response).to redirect_to(new_plan_path)
  end
end

shared_examples "show_user_today_plan" do
  it "redirects to the plan show page when the user has created the plan of today" do
    plan = Fabricate(:plan, user_id: current_user.id)
    action
    expect(response).to redirect_to(plan_path(plan))
  end
end