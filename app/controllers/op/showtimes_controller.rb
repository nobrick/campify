class Op::ShowtimesController < ApplicationController
  layout :resolve_layout
  before_action :authenticate_admin
  before_action :set_showtime, only: [ :show, :edit, :update, :destroy ]
  before_action :set_hidden_show_id_field, only: [ :new, :edit, :update, :create ]
  before_action :enable_render_op_links

  # GET /op/showtimes
  # GET /op/showtimes.json
  def index
    @showtimes = Showtime.order(created_at: :desc)
  end

  # GET /op/showtimes/1
  # GET /op/showtimes/1.json
  def show
    @ballot = @showtime.ballot || CampusBallot.new
  end

  # GET /op/showtimes/new
  def new
    show_id = params[:show_id]
    @hidden_show_id_field ||= Show.exists?(show_id)
    @showtime = Showtime.new(show_id: show_id)
  end

  # GET /op/showtimes/1/edit
  def edit
  end

  # POST /op/showtimes
  # POST /op/showtimes.json
  def create
    @showtime = Showtime.new(showtime_params)

    respond_to do |format|
      if @showtime.save
        format.html { redirect_to [ :op, @showtime ], notice: '创建活动场次成功。' }
        format.json { render :show, status: :created, location: @showtime }
      else
        format.html { render :new }
        format.json { render json: @showtime.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /op/showtimes/1
  # PATCH/PUT /op/showtimes/1.json
  def update
    respond_to do |format|
      if @showtime.update(showtime_params)
        format.html { redirect_to [ :op, @showtime ], notice: '更新活动场次成功。' }
        format.json { render :show, status: :ok, location: @showtime }
      else
        format.html { render :edit }
        format.json { render json: @showtime.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /op/showtimes/1
  # DELETE /op/showtimes/1.json
  def destroy
    @showtime.destroy
    respond_to do |format|
      format.html { redirect_to op_showtimes_url, notice: '删除活动场次成功。' }
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
    def set_showtime
      @showtime = Showtime.find(params[:id])
    end

    # Hide 'Show ID' field if necessary
    def set_hidden_show_id_field
      @hidden_show_id_field = !!params[:hidden_show_id_field]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def showtime_params
      params.require(:showtime).permit(:show_id, :title, :description, :starts_at, :ends_at, :ongoing)
    end
end
