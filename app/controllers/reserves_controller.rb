# -*- encoding: utf-8 -*-
class ReservesController < ApplicationController
  before_action :set_reserve, only: [:show, :edit, :update, :destroy]
  before_action :store_location, :only => [:index, :new]
  before_action :get_user, :only => [:index, :new]
  before_action :store_page
  after_action :verify_authorized
  after_action :convert_charset, :only => :index
  helper_method :get_manifestation
  helper_method :get_item

  # GET /reserves
  # GET /reserves.json
  def index
    authorize Reserve
    unless current_user.has_role?('Librarian')
      if @user
        if current_user == @user
          redirect_to reserves_url(:format => params[:format])
          return
        else
          access_denied; return
        end
      end
    end

    search = Reserve.search
    query = @query = params[:query].to_s.strip
    sort_by = params[:sort_by].to_s.downcase
    if sort_by == 'title'
      @sort_by = :title
      sort_column = :title_transcription
      order = :asc
    else
      @sort_by = :created_at
      sort_column = :created_at
      order = :desc
    end
    if params[:format].to_s.downcase == 'csv'
      page = 1
      per_page = 65534
    else
      page ||= params[:page] || 1
      per_page ||= Reserve.default_per_page
    end

    if params[:mode] == 'hold' and current_user.has_role?('Librarian')
      search.build do
        with(:hold).equal_to true
      end
    else
      if @user
        user = @user
        if current_user.has_role?('Librarian')
          search.build do
            with(:username).equal_to user.username
          end
        else
          access_denied; return
        end
      else
        unless current_user.has_role?('Librarian')
          search.build do
            with(:username).equal_to current_user.username
          end
        end
      end
    end

    begin
      reserved_from = Time.zone.parse(params[:reserved_from])
      @reserved_from = params[:reserved_from].to_s.strip
    rescue
      reserved_from = nil
    end

    begin
      reserved_to = Time.zone.parse(params[:reserved_to])
      @reserved_to = params[:reserved_to].to_s.strip
    rescue
      reserved_to = nil
    end

    if params[:state].present?
      state = params[:state].downcase
    end

    search.build do
      fulltext query
      if reserved_from
        with(:created_at).greater_than_or_equal_to reserved_from.beginning_of_day
      end
      if reserved_to
        with(:created_at).less_than reserved_to.tomorrow.beginning_of_day
      end
      order_by sort_column, order
      with(:state).equal_to state if state
      facet :state
      paginate :page => page.to_i, :per_page => per_page
    end

    @reserves = search.execute.results
    @state_facet = search.facet(:state).rows

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @reserves }
      format.rss  { render :layout => false }
      format.atom
      format.csv
    end
  end

  # GET /reserves/1
  # GET /reserves/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @reserve }
    end
  end

  # GET /reserves/new
  # GET /reserves/new.json
  def new
    @reserve = Reserve.new
    authorize @reserve

    if current_user.has_role?('Librarian')
      @reserve.user = @user
    else
      if @user.present?
        if @user != current_user
          access_denied; return
        end
      end
      @reserve.user_number = current_user.user_number
    end

    get_manifestation
    if @manifestation
      @reserve.manifestation = @manifestation
      if @reserve.user
        @reserve.expired_at = @manifestation.reservation_expired_period(@reserve.user).days.from_now.end_of_day
        if @manifestation.is_reserved_by?(@reserve.user)
          flash[:notice] = t('reserve.this_manifestation_is_already_reserved')
          redirect_to @manifestation
          return
        end
      end
    end
  end

  # GET /reserves/1/edit
  def edit
    @reserve.item_identifier = @reserve.item.try(:item_identifier)
  end

  # POST /reserves
  # POST /reserves.json
  def create
    @reserve = Reserve.new(reserve_params)
    @reserve.set_user
    authorize @reserve

    if current_user.has_role?('Librarian')
      unless @reserve.user
        @reserve.user = @user
      end
    else
      if @reserve.user != current_user
        if @user != current_user
          access_denied; return
        end
      end
    end

    respond_to do |format|
      if @reserve.save
        @reserve.sm_request!

        format.html { redirect_to @reserve, :notice => t('controller.successfully_created', :model => t('activerecord.models.reserve')) }
        format.json { render :json => @reserve, :status => :created, :location => reserve_url(@reserve) }
      else
        format.html { render :action => "new" }
        format.json { render :json => @reserve.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /reserves/1
  # PUT /reserves/1.json
  def update
    if params[:mode] != 'cancel'
      if current_user.has_role?('Librarian')
        @reserve.assign_attributes(admin_reserve_params)
      else
        @reserve.assign_attributes(user_reserve_params)
      end
    end

    if @reserve.valid?
      if params[:mode] == 'cancel'
        @reserve.sm_cancel!
      else
        if @reserve.retained?
          if @reserve.item_identifier and @reserve.force_retaining == '1'
            @reserve.sm_retain!
          end
        else
          @reserve.sm_retain! if @reserve.item_identifier
        end
      end
    end

    respond_to do |format|
      if @reserve.save
        if @reserve.state == 'canceled'
          flash[:notice] = t('reserve.reservation_was_canceled')
        else
          flash[:notice] = t('controller.successfully_updated', :model => t('activerecord.models.reserve'))
        end
        format.html { redirect_to @reserve }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @reserve.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /reserves/1
  # DELETE /reserves/1.json
  def destroy
    @reserve.destroy
    #flash[:notice] = t('reserve.reservation_was_canceled')

    if @reserve.manifestation.try(:is_reserved?)
      if @reserve.item
        retain = @reserve.item.retain(User.find(1)) # TODO: システムからの送信ユーザの設定
        if retain.nil?
          flash[:message] = t('reserve.this_item_is_not_reserved')
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to reserves_url, :notice => t('controller.successfully_deleted', :model => t('activerecord.models.reserve')) }
      format.json { head :no_content }
    end
  end

  private
  def set_reserve
    @reserve = Reserve.find(params[:id])
    authorize @reserve
  end

  def reserve_params
    params.require(:reserve).permit(
      :manifestation_id, :user_number, :expired_at
    )
  end

  def user_reserve_params
    params.require(:reserve).permit(
      :expired_at
    )
  end

  def admin_reserve_params
    params.require(:reserve).permit(
      :manifestation_id, :item_identifier, :user_number,
      :expired_at, :request_status_type, :canceled_at, :checked_out_at,
      :expiration_notice_to_patron, :expiration_notice_to_library, :item_id,
      :retained_at, :postponed_at, :force_retaining
    )
  end
end
