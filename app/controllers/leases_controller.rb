class LeasesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_record_unknown
rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  def create
    lease = Lease.create!(lease_params)
    render json: lease, status: :created
  end

  def destroy
    lease = find_lease
    lease.destroy
    head :no_content
  end

  private

  def lease_params
    params.permit(:tenant_id, :apartment_id, :rent)
  end

  def find_lease
    Lease.find_by!(id: params[:id])
  end

  def render_record_unknown
    render json: {error: "lease not found"}, status: :not_found
  end

  def render_record_invalid(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end

end
