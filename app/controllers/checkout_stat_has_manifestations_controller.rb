class CheckoutStatHasManifestationsController < ApplicationController
  before_action :set_checkout_stat_has_manifestation, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  # GET /checkout_stat_has_manifestations
  # GET /checkout_stat_has_manifestations.json
  def index
    authorize CheckoutStatHasManifestation
    @checkout_stat_has_manifestations = CheckoutStatHasManifestation.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @checkout_stat_has_manifestations }
    end
  end

  # GET /checkout_stat_has_manifestations/1
  # GET /checkout_stat_has_manifestations/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @checkout_stat_has_manifestation }
    end
  end

  # GET /checkout_stat_has_manifestations/new
  # GET /checkout_stat_has_manifestations/new.json
  def new
    @checkout_stat_has_manifestation = CheckoutStatHasManifestation.new
    authorize @checkout_stat_has_manifestation

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @checkout_stat_has_manifestation }
    end
  end

  # GET /checkout_stat_has_manifestations/1/edit
  def edit
  end

  # POST /checkout_stat_has_manifestations
  # POST /checkout_stat_has_manifestations.json
  def create
    @checkout_stat_has_manifestation = CheckoutStatHasManifestation.new(checkout_stat_has_manifestation_params)
    authorize @checkout_stat_has_manifestation

    respond_to do |format|
      if @checkout_stat_has_manifestation.save
        format.html { redirect_to @checkout_stat_has_manifestation, :notice => t('controller.successfully_created', :model => t('activerecord.models.checkout_stat_has_manifestation')) }
        format.json { render :json => @checkout_stat_has_manifestation, :status => :created, :location => @checkout_stat_has_manifestation }
      else
        format.html { render :action => "new" }
        format.json { render :json => @checkout_stat_has_manifestation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /checkout_stat_has_manifestations/1
  # PUT /checkout_stat_has_manifestations/1.json
  def update
    @checkout_stat_has_manifestation.assign_attributes(checkout_stat_has_manifestation_params)
    respond_to do |format|
      if @checkout_stat_has_manifestation.save
        format.html { redirect_to @checkout_stat_has_manifestation, :notice => t('controller.successfully_updated', :model => t('activerecord.models.checkout_stat_has_manifestation')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @checkout_stat_has_manifestation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /checkout_stat_has_manifestations/1
  # DELETE /checkout_stat_has_manifestations/1.json
  def destroy
    @checkout_stat_has_manifestation.destroy

    respond_to do |format|
      format.html { redirect_to checkout_stat_has_manifestations_url }
      format.json { head :no_content }
    end
  end

  private
  def set_checkout_stat_has_manifestation
    @checkout_stat_has_manifestation = CheckoutStatHasManifestation.find(params[:id])
    authorize @checkout_stat_has_manifestation
  end

  def checkout_stat_has_manifestation_params
    params.require(:checkout_stat_has_manifestation).permit(
      :manifestation_checkout_stat_id, :manifestation_id
    )
  end
end
