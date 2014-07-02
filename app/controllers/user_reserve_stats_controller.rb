class UserReserveStatsController < ApplicationController
  load_and_authorize_resource
  after_filter :convert_charset, :only => :show

  # GET /user_reserve_stats
  # GET /user_reserve_stats.json
  def index
    @user_reserve_stats = UserReserveStat.order('id DESC').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @user_reserve_stats }
    end
  end

  # GET /user_reserve_stats/1
  # GET /user_reserve_stats/1.json
  def show
    if params[:format] == 'csv'
      per_page = 65534
    else
      per_page = ReserveStatHasUser.default_per_page
    end
    @stats = @user_reserve_stat.reserve_stat_has_users.order('reserves_count DESC, user_id').page(params[:page]).per(per_page)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @user_reserve_stat }
      format.csv
    end
  end

  # GET /user_reserve_stats/new
  # GET /user_reserve_stats/new.json
  def new
    @user_reserve_stat = UserReserveStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @user_reserve_stat }
    end
  end

  # GET /user_reserve_stats/1/edit
  def edit
  end

  # POST /user_reserve_stats
  # POST /user_reserve_stats.json
  def create
    @user_reserve_stat = UserReserveStat.new(params[:user_reserve_stat])

    respond_to do |format|
      if @user_reserve_stat.save
        format.html { redirect_to @user_reserve_stat, :notice => t('controller.successfully_created', :model => t('activerecord.models.user_reserve_stat')) }
        format.json { render :json => @user_reserve_stat, :status => :created, :location => @user_reserve_stat }
      else
        format.html { render :action => "new" }
        format.json { render :json => @user_reserve_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_reserve_stats/1
  # PUT /user_reserve_stats/1.json
  def update
    respond_to do |format|
      if @user_reserve_stat.update_attributes(params[:user_reserve_stat])
        if @user_reserve_stat.mode == 'import'
          UserReserveStatQueue.perform(@user_reserve_stat.id)
        end
        format.html { redirect_to @user_reserve_stat, :notice => t('controller.successfully_updated', :model => t('activerecord.models.user_reserve_stat')) }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user_reserve_stat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_reserve_stats/1
  # DELETE /user_reserve_stats/1.json
  def destroy
    @user_reserve_stat.destroy

    respond_to do |format|
      format.html { redirect_to user_reserve_stats_url }
      format.json { head :no_content }
    end
  end
end
