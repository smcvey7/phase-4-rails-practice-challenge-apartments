class ApartmentsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_record_unknown
rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  def index
    apartments = Apartment.all
    render json: apartments
  end

  def show
    apartment = find_apartment
    render json: apartment
  end

  def create
    apartment = Apartment.create!(apartment_params)
    render json: apartment, status: :created
  end

  def update
    apartment = find_apartment
    apartment.update!(apartment_params)
    render json: apartment, status: :accepted
  end

  def destroy
    apartment = find_apartment
    apartment.destroy
    head :no_content
  end

  private

  def apartment_params
    params.permit(:number)
  end

  def find_apartment
    Apartment.find_by!(id: params[:id])
  end

  def render_record_unknown
    render json: {error: "apartment not found"}, status: :not_found
  end

  def render_record_invalid(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end

end
