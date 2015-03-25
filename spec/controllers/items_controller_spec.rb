require 'spec_helper'

describe ItemsController do
  let(:plan) { Fabricate(:plan) }

  describe "GET #new" do
    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { get :new, plan_id: plan.id }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      it "assigns the requested plan to @plan" do
        get :new, plan_id: plan.id
        expect(assigns(:plan)).to eq(plan)
      end

      it "renders the :new template" do
        get :new, plan_id: plan.id
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST #create" do
    let(:valid_item) { Fabricate.attributes_for(:item) }

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { post :create, plan_id: plan.id, item: valid_item }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      context "with valid attributes" do
        it "saves the new item in the database" do
          expect{
           post :create, plan_id: plan.id, item: valid_item
            }.to change(Item, :count).by(1)
        end

        it "creates a item associated the plan" do
          post :create, plan_id: plan.id, item: valid_item
          expect(Item.first.plan).to eq(plan)
        end

        it "redirects to the plan show page" do
          post :create, plan_id: plan.id, item: valid_item
          expect(response).to redirect_to(plan_path(plan))
        end
      end

      context "with invalid attributes" do
        let(:invalid_item) { Fabricate.attributes_for(:invalid_item) }

        it "doesn't save the new item in the database" do
          expect{
           post :create, plan_id: plan.id, item: invalid_item
            }.not_to change(Item, :count)
        end

        it "assigns the requested plan to @plan" do
          post :create, plan_id: plan.id, item: invalid_item
          expect(assigns(:plan)).to eq(plan)
        end

        it "re-renders the :new template" do
          post :create, plan_id: plan.id, item: invalid_item
          expect(response).to render_template(:new)
        end
      end
    end
  end

  describe "PATCH #update" do
    let(:item) { Fabricate(:item, plan_id: plan.id) }
    before { @item_attr = Fabricate.attributes_for(:item, name: "窄距俯卧撑", duration: 20, result: 100, unit: "个")}

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { patch :update, plan_id: plan.id, id: item.id, item: @item_attr }
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      context "with valid attributes" do
        it "updates attributes of the item in the database" do
          patch :update, plan_id: plan.id, id: item.id, item: @item_attr
          item.reload
          expect(item.name).to eq("窄距俯卧撑")
          expect(item.duration).to eq(20)
          expect(item.result).to eq(100)
          expect(item.unit).to eq("个")
        end

        it "redirects to the plan show page" do
          patch :update, plan_id: plan.id, id: item.id, item: @item_attr
          expect(response).to redirect_to(plan_path(plan.id))
        end
      end

      context "with invalid attributes" do
        before { @item_attr.update(name: nil) }

        it "doesn't update attributes of the item in the database" do
          patch :update, plan_id: plan.id, id: item.id, item: @item_attr
          item.reload
          expect(item.name).not_to eq(nil)
        end

        it "sets the error messages" do
          patch :update, plan_id: plan.id, id: item.id, item: @item_attr
          expect(flash[:danger]).not_to be_nil
        end

        it "re-renders the plan show page" do
          patch :update, plan_id: plan.id, id: item.id, item: @item_attr
          expect(response).to render_template :show
        end
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:item) { Fabricate(:item, plan_id: plan.id) }

    context "for the unauthenticated user" do
      it_behaves_like "require_signed_in" do
        let(:action) { delete :destroy, plan_id: plan.id, id: item.id }
      end
    end

    context "for the authenticated user" do
      before { sign_in }
      it "deletes the item" do
        expect{
         delete :destroy, plan_id: plan.id, id: item.id
          }.to change(Item, :count).by(-1)
      end

      it "redirects to the plan show page" do
        delete :destroy, plan_id: plan.id, id: item.id
        expect(response).to redirect_to(plan_path(plan))
      end

      it "does't delete the item that has be finished" do
        item = Fabricate(:item, plan_id: plan.id, finished: true)
        expect{
         delete :destroy, plan_id: plan.id, id: item.id
          }.not_to change(Item, :count)
      end

      it "does't delete the item that does not belong to the current plan" do
        other_plan = Fabricate(:plan)
        other_item = Fabricate(:item, plan_id: other_plan.id)
        expect{
         delete :destroy, plan_id: plan.id, id: other_item.id
          }.not_to change(Item, :count)
      end
    end
  end
end