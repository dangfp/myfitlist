require 'spec_helper'

describe PagesController do
  describe "GET #front" do
    context "for the unauthenticated user" do
      it "renders the :front template" do
        get :front
        expect(response).to render_template(:front)
      end
    end

    context "for the authenticated user" do
      before { sign_in }

      it_behaves_like "show_new_plan" do
        let(:action) { get :front }
      end

      it_behaves_like "show_user_today_plan" do
        let(:action) { get :front }
      end
    end
  end
end