class StationController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :show]
  
  def new
		if has_station?
			@station = Station.find_by(user_id: current_user.id)
			@user = current_user
			@name = @user.name
			@records = []
			@records[0] = Customer.where(station_id: @station.id)
			@records[1] = Gender.all
			render 'show'
		else
      @station = Station.new
		end
  end

  def create
		if has_station?
			@station = Station.find_by(user_id: current_user.id)
			@user = current_user
      @name = @user.name
			@records = []
			@records[0] = Customer.where(station_id: @station.id)
			@records[1] = Gender.all
			render 'show'	
		else
			@station = Station.new(user_id: current_user.id, sname: params[:station][:sname], city: params[:station][:city], province: params[:station][:province], address: params[:station][:address], pnumber: params[:station][:pnumber], logo: params[:station][:logo])
			if @station.save
				@user = current_user
        @name = @user.name
			  @records = []
			  @records[0] = Customer.where(station_id: @station.id)
			  @records[1] = Gender.all
				render 'show'
			else
				render 'new'
			end
		end
  end
end
