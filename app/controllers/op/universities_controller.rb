class Op::UniversitiesController < ApplicationController
  layout 'layouts/panel_grid'
  before_action :authenticate_admin
  before_action :set_university, only: [:show, :edit, :update, :destroy]
  before_action :enable_render_op_links

  # GET /op/universities
  # GET /op/universities.json
  def index
    @universities = University.all
  end

  # GET /op/universities/1
  # GET /op/universities/1.json
  def show
  end

  # GET /op/universities/new
  def new
    @university = University.new
  end

  # GET /op/universities/1/edit
  def edit
  end

  # POST /op/universities
  # POST /op/universities.json
  def create
    @university = University.new(university_params)

    respond_to do |format|
      if @university.save
        format.html { redirect_to [ :op, @university ], notice: '创建大学条目成功。' }
        format.json { render :show, status: :created, location: @university }
      else
        format.html { render :new }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /op/universities/1
  # PATCH/PUT /op/universities/1.json
  def update
    respond_to do |format|
      if @university.update(university_params)
        format.html { redirect_to [ :op, @university ], notice: '更新大学条目成功。' }
        format.json { render :show, status: :ok, location: @university }
      else
        format.html { render :edit }
        format.json { render json: @university.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /op/universities/1
  # DELETE /op/universities/1.json
  def destroy
    @university.destroy
    respond_to do |format|
      format.html { redirect_to op_universities_url, notice: '删除大学条目成功。' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_university
      @university = University.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def university_params
      params.require(:university).permit(:name, :city, :location)
    end
end
