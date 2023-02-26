class TenantsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_record_unknown
rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  def index
    tenant = Tenant.all
    render json: tenant
  end

  def show
    tenant = find_tenant
    render json: tenant
  end

  def create
    tenant = Tenant.create!(tenant_params)
    render json: tenant, status: :created
  end

  def update
    tenant = find_tenant
    tenant.update!(tenant_params)
    render json: tenant, status: :accepted
  end

  def destroy
    tenant = find_tenant
    tenant.destroy
    head :no_content
  end

  private

  def tenant_params
    params.permit(:age, :name)
  end

  def find_tenant
    Tenant.find_by!(id: params[:id])
  end

  def render_record_unknown
    render json: {error: "tenant not found"}, status: :not_found
  end

  def render_record_invalid(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end

end
