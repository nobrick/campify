class Uni::EnrollmentsController < ApplicationController
  before_action :authenticate_uni_user!
  before_action :set_enrollment, only: :destroy

  # POST /uni/enrollments
  def create
    @enrollment = Enrollment.new(enrollment_params)
    @enrollment.user = current_uni_user
    respond_to do |format|
      if @enrollment.save
        format.html { redirect_to uni_profile_show_path, notice: '报名成功。' }
      else
        format.html { redirect_to uni_profile_show_path, alert: '报名失败。' }
      end
    end
  end

  # DELETE /uni/enrollments/1
  def destroy
    allowed = @enrollment.present?
    @enrollment.destroy if allowed
    respond_to do |format|
      if allowed
        format.html { redirect_to uni_profile_show_path, notice: '取消报名成功。' }
      else
        format.html { redirect_to uni_profile_show_path, alert: '取消报名失败。' }
      end
    end
  end

  private

  def set_enrollment
    @enrollment = Enrollment.find(params[:id])
    @enrollment = nil if @enrollment.user != current_uni_user
  end

  def enrollment_params
    params.require(:enrollment).permit(:showtime_id)
  end
end
