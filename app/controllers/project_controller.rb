class ProjectController < ApplicationController
  before_action :logged_in_user, only: [:destroy, :create, :update, :list]
  
  def create
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 1
  			@station = Station.find params[:id_station]
	  		if params.has_key?(:map)
		  		@room = Project.new(station_id: @station.id, name: params[:name], lang: params[:lang], map: params[:map])
			  	if @room.save
				    render json: @room
  				else
	  			  render json: @room.errors, status: :unprocessable_entity
		  		end
			  else
				  @room = Project.new(station_id: @station.id, name: params[:name], lang: params[:lang])
  				if @room.save
	  			  render json: @room
		  		else
			  	  render json: @room.errors, status: :unprocessable_entity
				  end
  			end
	  	else
        head :no_content
      end
    else
      if has_station?
  			@station = Station.find_by(user_id: current_user.id)
	  		if params.has_key?(:map)
		  		@room = Project.new(station_id: @station.id, name: params[:name], lang: params[:lang], map: params[:map])
			  	if @room.save
				    render json: @room
  				else
	  			  render json: @room.errors, status: :unprocessable_entity
		  		end
			  else
				  @room = Project.new(station_id: @station.id, name: params[:name], lang: params[:lang])
  				if @room.save
	  			  render json: @room
		  		else
			  	  render json: @room.errors, status: :unprocessable_entity
				  end
  			end
	  	else
        redirect_to root_path
      end
    end
  end

  def update
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 2
        @station = Station.find params[:id_station]
		  	@room = Project.find(params[:id])
			  if @station.id == @room.station_id
				  if params.has_key?(:map)
					  if @room.update(name: params[:name],lang: params[:lang],map: params[:map])
						  render json: @room
  					else
	  					render json: @room.errors, status: :unprocessable_entity
		  			end
			  	else
				  	if @room.update(name: params[:name],lang: params[:lang])
					  	render json: @room
  					else
	  					render json: @room.errors, status: :unprocessable_entity
		  			end
			  	end
  			end
      else
        head :no_content
      end
    else
      if has_station?
        @station = Station.find_by(user_id: current_user.id)
		  	@room = Project.find(params[:id])
			  if @station.id == @room.station_id
				  if params.has_key?(:map)
					  if @room.update(name: params[:name],lang: params[:lang],map: params[:map])
						  render json: @room
  					else
	  					render json: @room.errors, status: :unprocessable_entity
		  			end
			  	else
				  	if @room.update(name: params[:name],lang: params[:lang])
					  	render json: @room
  					else
	  					render json: @room.errors, status: :unprocessable_entity
		  			end
			  	end
  			end
      else
        redirect_to root_path
      end
    end
  end

  def destroy
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 3
  			@station = Station.find params[:id_station]
	  		@room = Project.find(params[:id])
		  	if @room.station_id == @station.id
			  	@room.destroy
				  head :no_content
  			end
      end
    else
		  if has_station?
  			@station = Station.find_by(user_id: current_user.id)
	  		@room = Project.find(params[:id])
		  	if @room.station_id == @station.id
			  	@room.destroy
				  head :no_content
  			end
	  	else
		  	redirect_to root_path
  		end
	  end
  end

  def list
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 4
  			@station = Station.find params[:id_station]
	  		@data = []
		  	@data[0] = Project.all
  			render json: @data
	  	else
        head :no_content
      end
    else
		  if has_station?
  			@station = Station.find_by(user_id: current_user.id)
	  		@data = []
		  	@data[0] = Project.all
  			render json: @data
	  	else
        redirect_to root_path
      end
	  end
  end
  
  def search
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 4
        @station = Station.find params[:id_station]
        if params.has_key?(:project_name)
          @supplier = Project.where("project_name LIKE ?" , "%#{params[:project_name]}%").group(:project_name).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:contractor)
					@supplier = Project.where("contractor LIKE ?" , "%#{params[:contractor]}%").group(:contractor).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:basic_info)
					@supplier = Project.where("basic_info LIKE ?" , "%#{params[:basic_info]}%").group(:basic_info).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Project.where("address LIKE ?" , "%#{params[:address]}%").group(:address).limit(5)
			    render json:@supplier
			  end
      else
        head :no_content
      end
    else
      if has_station?
        @station = Station.find_by(user_id: current_user.id)
        if params.has_key?(:project_name)
          @supplier = Project.where("project_name LIKE ?" , "%#{params[:project_name]}%").group(:project_name).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:contractor)
					@supplier = Project.where("contractor LIKE ?" , "%#{params[:contractor]}%").group(:contractor).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:basic_info)
					@supplier = Project.where("basic_info LIKE ?" , "%#{params[:basic_info]}%").group(:basic_info).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Project.where("address LIKE ?" , "%#{params[:address]}%").group(:address).limit(5)
			    render json:@supplier
			  end
      else
        redirect_to root_path
      end
    end
  end
  
  def find
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 4
        @station = Station.find params[:id_station]
        if params.has_key?(:date)
          n = params[:date].to_i
          start = n.days.ago.beginning_of_day
          fin = Time.now
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start = params[:begin_date].to_date.beginning_of_day
          fin = params[:end_date].to_date.end_of_day
        else
          start = Project.order(created_at: :asc).first.created_at
          fin = Time.now
        end
        if params.has_key?(:project_name)
          @supplier = Project.where(created_at: start..fin).where("project_name LIKE ?" , "%#{params[:project_name]}%").group(:project_name).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:contractor)
					@supplier = Project.where(created_at: start..fin).where("contractor LIKE ?" , "%#{params[:contractor]}%").group(:contractor).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:basic_info)
					@supplier = Project.where(created_at: start..fin).where("basic_info LIKE ?" , "%#{params[:basic_info]}%").group(:basic_info).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Project.where(created_at: start..fin).where("address LIKE ?" , "%#{params[:address]}%").group(:address).limit(5)
			    render json:@supplier
			  end
      else
        head :no_content
      end
    else
      if has_station?
        @station = Station.find_by(user_id: current_user.id)
        if params.has_key?(:date)
          n = params[:date].to_i
          start = n.days.ago.beginning_of_day
          fin = Time.now
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start = params[:begin_date].to_date.beginning_of_day
          fin = params[:end_date].to_date.end_of_day
        else
          start = Project.order(created_at: :asc).first.created_at
          fin = Time.now
        end
        if params.has_key?(:project_name)
          @supplier = Project.where(created_at: start..fin).where("project_name LIKE ?" , "%#{params[:project_name]}%").group(:project_name).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:contractor)
					@supplier = Project.where(created_at: start..fin).where("contractor LIKE ?" , "%#{params[:contractor]}%").group(:contractor).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:basic_info)
					@supplier = Project.where(created_at: start..fin).where("basic_info LIKE ?" , "%#{params[:basic_info]}%").group(:basic_info).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Project.where(created_at: start..fin).where("address LIKE ?" , "%#{params[:address]}%").group(:address).limit(5)
			    render json:@supplier
			  end
      else
        redirect_to root_path
      end
    end
  end
  
  
  private
  	# Confirms a logged-in user.
		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_url
			end
		end
end
