class PpcNumbersController < ApplicationController

  before_filter :authenticate_user!

  def create
    @location = Location.find_by_id(params[:location_id]) || Location.find_by_urn(params[:location_id])
    @ppc_number = @location.ppc_numbers.new(ppc_number_params)
    
    if @ppc_number.save
      expire_cached_json
      redirect_to edit_location_path(@location), notice: "The #{@ppc_number.cpm_code} number for #{@location.name} has been updated"
    else
      # render action: 'edit'
      redirect_to edit_location_path(@location), alert: "The PPC number was not saved. You must enter a unique CPM code and a phone number."
    end
  end

  def update
    @ppc_number = PpcNumber.find(params[:id])
    @location = @ppc_number.location

    if @ppc_number.update_attributes(ppc_number_params)
      expire_cached_json
      redirect_to edit_location_path(@location), notice: "The #{@ppc_number.cpm_code} number for #{@location.name} has been updated"
    else
      # render action: 'edit'
      redirect_to edit_location_path(@location), alert: "The PPC number was not saved. You must enter a unique CPM code and a phone number."
    end
  end

  def destroy
    ppc_number = PpcNumber.find(params[:id])
    @location = ppc_number.location

    if ppc_number.destroy
      expire_cached_json
      redirect_to edit_location_path(@location), notice: 'PPC Number was successfully deleted.' 
    else
      redirect_to edit_location_path(@location), alert: 'The PPC Number could not be deleted.' 
    end
  end

  private

  def ppc_number_params
    params.require(:ppc_number).permit(:cpm_code, :number, :notes)
  end

  def expire_cached_json
    expire_action(:controller => '/clients', :action => 'show', :id => @location.client.urn, format: :json)
  end
end
