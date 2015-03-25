require 'spec_helper'

describe SessionsController do
  describe "GET #new" do
    context "for unauthenticated user" do
      it "renders the :new template" do
        get :new
        expect(response).to render_template :new
      end
    end
    
    context "for authenticated user" do
      before { sign_in }

      it_behaves_like "show_new_plan" do
        let(:action) { get :new }
      end

      it_behaves_like "show_user_today_plan" do
        let(:action) { get :new }
      end
    end
  end

  describe "POST #create" do
    let!(:valid_user) { Fabricate(:user) }

    context "with the valid credentials" do
      it "puts the signed in user in the session" do
        post :create, email: valid_user.email, password: valid_user.password
        expect(session[:user_id]).to eq(valid_user.id)
      end

      it "redirects to the new plan page when the user doesn't create the plan of today" do
        post :create, email: valid_user.email, password: valid_user.password
        expect(response).to redirect_to(new_plan_path)
      end

      it "redirects to the plan show page when the user has created the plan of today" do
        plan = Fabricate(:plan, user_id: valid_user.id)
        post :create, email: valid_user.email, password: valid_user.password
        expect(response).to redirect_to(plan_path(plan))
      end
    end

    context "with the invalid credentials" do
      before { post :create, email: valid_user.email, password: valid_user.password + "123" }

      it "doesn't put the sign in user in the session" do
        expect(session[:user_id]).to be_nil
      end

      it "re-renders the :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #destroy" do
    before { session[:user_id] = Fabricate(:user).id }

    it "clears the session for the user" do
      get :destroy
      expect(session[:user_id]).to be_nil
    end

    it "redirects to the root path" do
      get :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end