require 'spec_helper'

describe ReserveStatHasManifestationsController do
  fixtures :all

  describe "GET index" do
    before(:each) do
      FactoryGirl.create(:reserve_stat_has_manifestation)
    end

    describe "When logged in as Administrator" do
      login_admin

      it "assigns all reserve_stat_has_manifestations as @reserve_stat_has_manifestations" do
        get :index
        assigns(:reserve_stat_has_manifestations).should eq(ReserveStatHasManifestation.page(1))
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns all reserve_stat_has_manifestations as @reserve_stat_has_manifestations" do
        get :index
        assigns(:reserve_stat_has_manifestations).should eq(ReserveStatHasManifestation.page(1))
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns all reserve_stat_has_manifestations as @reserve_stat_has_manifestations" do
        get :index
        assigns(:reserve_stat_has_manifestations).should be_nil
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "assigns all reserve_stat_has_manifestations as @reserve_stat_has_manifestations" do
        get :index
        assigns(:reserve_stat_has_manifestations).should be_nil
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET show" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
        get :show, :id => reserve_stat_has_manifestation.id
        assigns(:reserve_stat_has_manifestation).should eq(reserve_stat_has_manifestation)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
        get :show, :id => reserve_stat_has_manifestation.id
        assigns(:reserve_stat_has_manifestation).should eq(reserve_stat_has_manifestation)
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
        get :show, :id => reserve_stat_has_manifestation.id
        assigns(:reserve_stat_has_manifestation).should eq(reserve_stat_has_manifestation)
      end
    end

    describe "When not logged in" do
      it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
        get :show, :id => reserve_stat_has_manifestation.id
        assigns(:reserve_stat_has_manifestation).should eq(reserve_stat_has_manifestation)
      end
    end
  end

  describe "GET new" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        get :new
        assigns(:reserve_stat_has_manifestation).should_not be_valid
        response.should be_success
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "should not assign the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        get :new
        assigns(:reserve_stat_has_manifestation).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When logged in as User" do
      login_user

      it "should not assign the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        get :new
        assigns(:reserve_stat_has_manifestation).should_not be_valid
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        get :new
        assigns(:reserve_stat_has_manifestation).should_not be_valid
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "GET edit" do
    describe "When logged in as Administrator" do
      login_admin

      it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
        get :edit, :id => reserve_stat_has_manifestation.id
        assigns(:reserve_stat_has_manifestation).should eq(reserve_stat_has_manifestation)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
        get :edit, :id => reserve_stat_has_manifestation.id
        assigns(:reserve_stat_has_manifestation).should eq(reserve_stat_has_manifestation)
      end
    end

    describe "When logged in as User" do
      login_user

      it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
        get :edit, :id => reserve_stat_has_manifestation.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "should not assign the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
        reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
        get :edit, :id => reserve_stat_has_manifestation.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end

  describe "POST create" do
    before(:each) do
      @attrs = FactoryGirl.attributes_for(:reserve_stat_has_manifestation)
      @invalid_attrs = {:manifestation_reserve_stat_id => ''}
    end

    describe "When logged in as Administrator" do
      login_admin

      describe "with valid params" do
        it "assigns a newly created reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          post :create, :reserve_stat_has_manifestation => @attrs
          assigns(:reserve_stat_has_manifestation).should be_valid
        end

        it "redirects to the created patron" do
          post :create, :reserve_stat_has_manifestation => @attrs
          response.should redirect_to(assigns(:reserve_stat_has_manifestation))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          post :create, :reserve_stat_has_manifestation => @invalid_attrs
          assigns(:reserve_stat_has_manifestation).should_not be_valid
        end

        it "re-renders the 'new' template" do
          post :create, :reserve_stat_has_manifestation => @invalid_attrs
          response.should render_template("new")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      describe "with valid params" do
        it "assigns a newly created reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          post :create, :reserve_stat_has_manifestation => @attrs
          assigns(:reserve_stat_has_manifestation).should be_valid
        end

        it "should be forbidden" do
          post :create, :reserve_stat_has_manifestation => @attrs
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          post :create, :reserve_stat_has_manifestation => @invalid_attrs
          assigns(:reserve_stat_has_manifestation).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :reserve_stat_has_manifestation => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When logged in as User" do
      login_user

      describe "with valid params" do
        it "assigns a newly created reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          post :create, :reserve_stat_has_manifestation => @attrs
          assigns(:reserve_stat_has_manifestation).should be_valid
        end

        it "should be forbidden" do
          post :create, :reserve_stat_has_manifestation => @attrs
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          post :create, :reserve_stat_has_manifestation => @invalid_attrs
          assigns(:reserve_stat_has_manifestation).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :reserve_stat_has_manifestation => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "assigns a newly created reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          post :create, :reserve_stat_has_manifestation => @attrs
          assigns(:reserve_stat_has_manifestation).should be_valid
        end

        it "should be forbidden" do
          post :create, :reserve_stat_has_manifestation => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          post :create, :reserve_stat_has_manifestation => @invalid_attrs
          assigns(:reserve_stat_has_manifestation).should_not be_valid
        end

        it "should be forbidden" do
          post :create, :reserve_stat_has_manifestation => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
      @attrs = FactoryGirl.attributes_for(:reserve_stat_has_manifestation)
      @invalid_attrs = {:manifestation_reserve_stat_id => ''}
    end

    describe "When logged in as Administrator" do
      login_admin

      describe "with valid params" do
        it "updates the requested reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @attrs
        end

        it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @attrs
          assigns(:reserve_stat_has_manifestation).should eq(@reserve_stat_has_manifestation)
          response.should redirect_to(@reserve_stat_has_manifestation)
        end
      end

      describe "with invalid params" do
        it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @invalid_attrs
          response.should render_template("edit")
        end
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      describe "with valid params" do
        it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @attrs
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @invalid_attrs
          assigns(:reserve_stat_has_manifestation).should eq(@reserve_stat_has_manifestation)
        end

        it "should be forbidden" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When logged in as User" do
      login_user

      describe "with valid params" do
        it "updates the requested reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @attrs
          assigns(:reserve_stat_has_manifestation).should eq(@reserve_stat_has_manifestation)
          response.should be_forbidden
        end
      end

      describe "with invalid params" do
        it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @invalid_attrs
          response.should be_forbidden
        end
      end
    end

    describe "When not logged in" do
      describe "with valid params" do
        it "updates the requested reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @attrs
        end

        it "should be forbidden" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @attrs
          response.should redirect_to(new_user_session_url)
        end
      end

      describe "with invalid params" do
        it "assigns the requested reserve_stat_has_manifestation as @reserve_stat_has_manifestation" do
          put :update, :id => @reserve_stat_has_manifestation.id, :reserve_stat_has_manifestation => @invalid_attrs
          response.should redirect_to(new_user_session_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @reserve_stat_has_manifestation = FactoryGirl.create(:reserve_stat_has_manifestation)
    end

    describe "When logged in as Administrator" do
      login_admin

      it "destroys the requested reserve_stat_has_manifestation" do
        delete :destroy, :id => @reserve_stat_has_manifestation.id
      end

      it "redirects to the reserve_stat_has_manifestations list" do
        delete :destroy, :id => @reserve_stat_has_manifestation.id
        response.should redirect_to(reserve_stat_has_manifestations_url)
      end
    end

    describe "When logged in as Librarian" do
      login_librarian

      it "destroys the requested reserve_stat_has_manifestation" do
        delete :destroy, :id => @reserve_stat_has_manifestation.id
      end

      it "redirects to the reserve_stat_has_manifestations list" do
        delete :destroy, :id => @reserve_stat_has_manifestation.id
        response.should be_forbidden
      end
    end

    describe "When logged in as User" do
      login_user

      it "destroys the requested reserve_stat_has_manifestation" do
        delete :destroy, :id => @reserve_stat_has_manifestation.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @reserve_stat_has_manifestation.id
        response.should be_forbidden
      end
    end

    describe "When not logged in" do
      it "destroys the requested reserve_stat_has_manifestation" do
        delete :destroy, :id => @reserve_stat_has_manifestation.id
      end

      it "should be forbidden" do
        delete :destroy, :id => @reserve_stat_has_manifestation.id
        response.should redirect_to(new_user_session_url)
      end
    end
  end
end
