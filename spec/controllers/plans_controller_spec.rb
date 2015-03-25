require 'spec_helper'

describe PlansController do
  describe "GET #new" do
    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { get :new }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      context "the user hasn't today plan" do
        it "assigns a new Plan to @plan" do
          get :new
          expect(assigns(:plan)).to be_a_new(Plan)
        end

        it "renders the :new template" do
          get :new
          expect(response).to render_template :new
        end
      end
      
      context "the user has today plan" do
        let!(:today_plan) { Fabricate(:plan, user: current_user) }

        it "displays the error message" do
          get :new
          expect(flash[:danger]).not_to be_nil
        end

        it "redirects to the plan show page" do
          get :new
          expect(response).to redirect_to(plan_path(today_plan))
        end
      end
    end
  end

  describe "GET #show" do
    let(:plan) { Fabricate(:plan) }

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { get :show,  id: plan.id }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      it "assigns a plan to the @plan" do
        get :show, id: plan.id
        expect(assigns(:plan)).to eq(plan)
      end

      it "renders the plan show template" do
        get :show, id: plan.id
        expect(response).to render_template :show
      end
    end
  end

  describe "POST #create" do
    let(:valid_plan) { Fabricate.attributes_for(:plan, weight: 100.0) }

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action)  { post :create, plan: valid_plan}
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      context "with valid attributes" do
        it "saves a new plan in the database" do
          expect{
           post :create, plan: valid_plan
            }.to change(Plan, :count).by(1)
        end

        it "create a plan associated with the current user" do
          post :create, plan: valid_plan
          expect(Plan.first.user_id).to eq(current_user.id)
        end

        it "redirects to the plan show page" do
          post :create, plan: valid_plan
          valid_plan = Plan.find_by(weight: 100.0)
          expect(response).to redirect_to(plan_path(valid_plan))
        end
      end

      context "with invalid attributes" do
        let(:invalid_plan) { Fabricate.attributes_for(:invalid_plan) }

        it "doesn't save a new plan in the database" do
          expect{
           post :create, plan: invalid_plan
            }.not_to change(Plan, :count)
        end

        it "re-renders the :new template" do
          post :create, plan: invalid_plan
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:plan) { Fabricate(:plan, weight: 60) }
    before { @plan_attr = Fabricate.attributes_for(:plan, weight: 70) }

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { patch :update, id: plan.id, plan: @plan_attr }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      context "with valid attributes" do
        it "updates attributes of the plan in the database" do
          patch :update, id: plan.id, plan: @plan_attr
          plan.reload
          expect(plan.weight).to eq(70)
        end

        it "redirects to the plan show page" do
          patch :update, id: plan.id, plan: @plan_attr
          expect(response).to redirect_to(plan_path(plan))
        end
      end

      context "with invalid attributes" do
        before { @plan_attr.update(weight: 0) }

        it "doesn't update attributes of the plan in the database" do
          patch :update, id: plan.id, plan: @plan_attr
          plan.reload
          expect(plan.weight).to eq(60)
        end

        it "re-renders the plan show page" do
          patch :update, id: plan.id, plan: @plan_attr
          expect(response).to render_template :show
        end
      end
    end
  end
end