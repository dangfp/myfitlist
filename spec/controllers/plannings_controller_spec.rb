require 'spec_helper'

describe PlanningsController do
  describe "GET #new" do
    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { get :new }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      context "the user hasn't today planning" do
        it "assigns a new Planning to @planning" do
          get :new
          expect(assigns(:planning)).to be_a_new(Planning)
        end

        it "renders the :new template" do
          get :new
          expect(response).to render_template :new
        end
      end
      
      context "the user has today planning" do
        let!(:today_planning) { Fabricate(:planning, user: current_user) }

        it "displays the error message" do
          get :new
          expect(flash[:danger]).not_to be_nil
        end

        it "redirects to the planning show page" do
          get :new
          expect(response).to redirect_to(planning_path(today_planning))
        end
      end
    end
  end

  describe "GET #show" do
    let(:planning) { Fabricate(:planning) }

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { get :show,  id: planning.id }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      it "assigns a planning to the @planning" do
        get :show, id: planning.id
        expect(assigns(:planning)).to eq(planning)
      end

      it "renders the planning show template" do
        get :show, id: planning.id
        expect(response).to render_template :show
      end
    end
  end

  describe "POST #create" do
    let(:valid_planning) { Fabricate.attributes_for(:planning, weight: 100.0) }

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action)  { post :create, planning: valid_planning}
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      context "with valid attributes" do
        it "saves a new planning in the database" do
          expect{
           post :create, planning: valid_planning
            }.to change(Planning, :count).by(1)
        end

        it "create a planning associated with the current user" do
          post :create, planning: valid_planning
          expect(Planning.first.user_id).to eq(current_user.id)
        end

        it "redirects to the planning show page" do
          post :create, planning: valid_planning
          valid_planning = Planning.find_by(weight: 100.0)
          expect(response).to redirect_to(planning_path(valid_planning))
        end
      end

      context "with invalid attributes" do
        let(:invalid_planning) { Fabricate.attributes_for(:invalid_planning) }

        it "doesn't save a new planning in the database" do
          expect{
           post :create, planning: invalid_planning
            }.not_to change(Planning, :count)
        end

        it "re-renders the :new template" do
          post :create, planning: invalid_planning
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:planning) { Fabricate(:planning, weight: 60) }
    before { @planning_attr = Fabricate.attributes_for(:planning, weight: 70) }

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { patch :update, id: planning.id, planning: @planning_attr }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      context "with valid attributes" do
        it "updates attributes of the planning in the database" do
          patch :update, id: planning.id, planning: @planning_attr
          planning.reload
          expect(planning.weight).to eq(70)
        end

        it "redirects to the planning show page" do
          patch :update, id: planning.id, planning: @planning_attr
          expect(response).to redirect_to(planning_path(planning))
        end
      end

      context "with invalid attributes" do
        before { @planning_attr.update(weight: 0) }

        it "doesn't update attributes of the planning in the database" do
          patch :update, id: planning.id, planning: @planning_attr
          planning.reload
          expect(planning.weight).to eq(60)
        end

        it "re-renders the planning show page" do
          patch :update, id: planning.id, planning: @planning_attr
          expect(response).to render_template :show
        end
      end
    end
  end
end