class Op::ShowsController < ApplicationController
  layout :resolve_layout
  before_action :authenticate_admin
  before_action :set_show, only: [ :show, :edit, :update, :destroy ]

  # GET /op/shows
  # GET /op/shows.json
  def index
    @shows = Show.order(created_at: :desc)
  end

  # GET /op/shows/1
  # GET /op/shows/1.json
  def show
  end

  # GET /op/shows/new
  def new
    @show = Show.new
  end

  # GET /op/shows/1/edit
  def edit
  end

  # POST /op/shows
  # POST /op/shows.json
  def create
    @show = Show.new(show_params)
    @show.proposer = current_uni_user

    respond_to do |format|
      if @show.save
        format.html { redirect_to op_show_url(@show), notice: '创建活动成功。' }
        format.json { render :show, status: :created, location: @show }
      else
        format.html { render :new }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /op/shows/1
  # PATCH/PUT /op/shows/1.json
  def update
    respond_to do |format|
      if @show.update(show_params)
        format.html { redirect_to op_show_url(@show), notice: '更新活动成功。' }
        format.json { render :show, status: :ok, location: @show }
      else
        format.html { render :edit }
        format.json { render json: @show.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /op/shows/1
  # DELETE /op/shows/1.json
  def destroy
    @show.destroy
    respond_to do |format|
      format.html { redirect_to op_shows_url, notice: '删除活动成功。' }
      format.json { head :no_content }
    end
  end

  private
    def resolve_layout
      case action_name
      when 'index', 'show'
        'layouts/panel'
      else
        'layouts/panel_grid'
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_show
      @show = Show.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def show_params
      params.require(:show).permit(:name, :category, :description)
    end
end
