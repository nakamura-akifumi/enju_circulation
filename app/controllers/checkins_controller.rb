class CheckinsController < ApplicationController
  load_and_authorize_resource :except => :index
  authorize_resource :only => :index
  before_filter :get_basket, :only => [:index, :create]

  # GET /checkins
  # GET /checkins.json
  def index
    if @basket
      @checkins = @basket.checkins.page(params[:page])
    else
      @checkins = Checkin.page(params[:page])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @checkins }
      format.js
    end
  end

  # GET /checkins/1
  # GET /checkins/1.json
  def show
    #@checkin = Checkin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checkin }
    end
  end

  # GET /checkins/new
  def new
    flash[:message] = nil
    if flash[:checkin_basket_id]
      @basket = Basket.find(flash[:checkin_basket_id])
    else
      @basket = Basket.new
      @basket.user = current_user
      @basket.save!
    end
    @checkin = Checkin.new
    @checkins = Kaminari::paginate_array([]).page(1)
    flash[:checkin_basket_id] = @basket.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @checkin }
    end
  end

  # GET /checkins/1/edit
  def edit
    #@checkin = Checkin.find(params[:id])
  end

  # POST /checkins
  # POST /checkins.json
  def create
    unless @basket
      access_denied; return
    end
    @checkin.basket = @basket
    @checkin.librarian = current_user

    flash[:message] = ''

    respond_to do |format|
      if @checkin.save
        message = @checkin.item_checkin(current_user)
        if @checkin.checkout
          flash[:message] << t('checkin.successfully_checked_in')
        else
          flash[:message] << t('checkin.not_checked_out')
        end
        flash[:message] << message if message
        format.html { redirect_to basket_checkins_url(@checkin.basket) }
        format.json { render :json => @checkin, :status => :created, :location => @checkin }
        format.js { redirect_to basket_checkins_url(@basket, :format => :js) }
      else
        @checkins = @basket.checkins.page(1)
        format.html { render :action => "new" }
        format.json { render :json => @checkin.errors, :status => :unprocessable_entity }
        format.js { render :action => "index" }
      end
    end
  end

  # PUT /checkins/1
  # PUT /checkins/1.json
  def update
    @checkin.assign_attributes(params[:checkin])
    @checkin.librarian = current_user

    respond_to do |format|
      if @checkin.save
        format.html { redirect_to @checkin, :notice => t('controller.successfully_updated', :model => t('activerecord.models.checkin')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @checkin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checkins/1
  # DELETE /checkins/1.json
  def destroy
    #@checkin = Checkin.find(params[:id])
    @checkin.destroy

    respond_to do |format|
      format.html { redirect_to checkins_url }
      format.json { head :no_content }
    end
  end
end
