class HotspotsController < ApplicationController
    before_action :authenticate_admin!, :except => [:show, :index]

    def index

        if params[:user_address]
            user_addr = params[:user_address]
            @current_location = Hotspot.new(street_address: user_addr[:street_address], city: user_addr[:city], zip_code: user_addr[:zip_code])
            @current_location.geocode
            @hotspots = Hotspot.address_sort(@current_location)
        else
            @hotspots = Hotspot.order(city: :asc).page(params[:page])
        end
    end

    def new
        @hotspot = Hotspot.new
    end

    def create
        @hotspot = Hotspot.create(hotspot_params)

        puts "ERRORS: #{@hotspot.errors.to_a}"
        puts "VALID?: #{@hotspot.valid?}"

        if @hotspot.valid?
            flash[:success] = "Hotspot created succesfully."
        else
            flash[:alert] = "Hotspot could not be saved."
        end

        redirect_to hotspots_path
    end

    def edit
        @hotspot = Hotspot.find(params[:id])
    end

    def update
        @hotspot = Hotspot.find(params[:id])
        if @hotspot.update_attributes(hotspot_params)
            flash[:success] = "Hotspot updated succesfully."
        else
            flash[:alert] = "There was an error updating the hotspot."
        end
        redirect_to hotspots_path(@hotspot)
    end

    def destroy
        @hotspot = Hotspot.find(params[:id]).destroy

            flash[:notice] = "The hotspot was deleted succesfully."

        redirect_to hotspots_path
    end

    private

    def hotspot_params
        params.require(:hotspot).permit(:title, :street_address, :city, :state, :zip_code, :phone_number, :website)
    end

    #test
end
