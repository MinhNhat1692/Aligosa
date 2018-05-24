class CustomerController < ApplicationController
  before_action :logged_in_user, only: [:edit, :create, :update, :destroy]

  def create
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 1
			  @station = Station.find params[:id_station]
  			if params.has_key?(:email)
	  			@checkuser = User.find_by(email: params[:email])
		  		if @checkuser != nil
			  		@checksaleprofile = SaleProfile.find_by(user_id: @checkuser.id)
				  	if @checksaleprofile != nil
					  	@customer = Customer.new(user_id: @checkuser.id, station_id: @station.id, customer_name: params[:customer_name], address: params[:address], pnumber: params[:pnumber], avatar: params[:avatar], gender: params[:gender], noid: params[:noid], email: params[:email])
						  if @customer.save
  							render json: @customer
	  						#@customer.send_activation_email(@checkuser,@station,@customer)
		  				else
			  				render json: @customer.errors, status: :unprocessable_entity
				  		end
					  else
						  @customer = Customer.new(station_id: @station.id, customer_name: params[:customer_name], address: params[:address], pnumber: params[:pnumber], avatar: params[:avatar], gender: params[:gender], noid: params[:noid], email: params[:email])
  						if @customer.save
	  						render json: @customer
		  				else
			  				render json: @customer.errors, status: :unprocessable_entity
				  		end
					  end
  				else
	  				@customer = Customer.new(station_id: @station.id, customer_name: params[:customer_name], address: params[:address], pnumber: params[:pnumber], avatar: params[:avatar], gender: params[:gender], noid: params[:noid], email: params[:email])
		  			if @customer.save
			  			render json: @customer
				  	else
					  	render json: @customer.errors, status: :unprocessable_entity
  					end
	  			end
		  	else
			  	@customer = Customer.new(station_id: @station.id, customer_name: params[:customer_name], address: params[:address], pnumber: params[:pnumber], avatar: params[:avatar], gender: params[:gender], noid: params[:noid], email: params[:email])
				  if @customer.save
					  render json: @customer
  				else
	  				render json: @customer.errors, status: :unprocessable_entity
		  		end
			  end
      else
        head :no_content
      end
    else
      if has_station?
			  @station = Station.find_by(user_id: current_user.id)
  			if params.has_key?(:email)
	  			@checkuser = User.find_by(email: params[:email])
		  		if @checkuser != nil
			  		@checksaleprofile = SaleProfile.find_by(user_id: @checkuser.id)
				  	if @checksaleprofile != nil
					  	@customer = Customer.new(user_id: @checkuser.id, station_id: @station.id , customer_name: params[:customer_name], address: params[:address], pnumber: params[:pnumber], gender: params[:gender], noid: params[:noid], email: params[:email], avatar: params[:avatar])
						  if @customer.save
  							render json: @customer
	  						#@customer.send_activation_email(@checkuser,@station,@customer)
		  				else
			  				render json: @customer.errors, status: :unprocessable_entity
				  		end
					  else
						  @customer = Customer.new(station_id: @station.id, customer_name: params[:customer_name], address: params[:address], pnumber: params[:pnumber], avatar: params[:avatar], gender: params[:gender], noid: params[:noid], email: params[:email])
  						if @customer.save
	  						render json: @customer
		  				else
			  				render json: @customer.errors, status: :unprocessable_entity
				  		end
					  end
  				else
	  				@customer = Customer.new(station_id: @station.id, customer_name: params[:customer_name], address: params[:address], pnumber: params[:pnumber], avatar: params[:avatar], gender: params[:gender], noid: params[:noid], email: params[:email])
		  			if @customer.save
			  			render json: @customer
				  	else
					  	render json: @customer.errors, status: :unprocessable_entity
  					end
	  			end
		  	else
			  	@customer = Customer.new(station_id: @station.id, customer_name: params[:customer_name], address: params[:address], pnumber: params[:pnumber], avatar: params[:avatar], gender: params[:gender], noid: params[:noid], email: params[:email])
				  if @customer.save
					  render json: @customer
  				else
	  				render json: @customer.errors, status: :unprocessable_entity
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
  			@customer = Customer.find(params[:id])
	  		if @customer.station_id == @station.id
		  		if params.has_key?(:avatar)
			  		if @customer.update(customer_name: params[:customer_name], email: params[:email], address: params[:address], pnumber: params[:pnumber], noid: params[:noid], gender: params[:gender],avatar: params[:avatar])
              render json: @customer
					  else
						  render json: @customer.errors, status: :unprocessable_entity
  					end
	  			else
		  			if @customer.update(customer_name: params[:customer_name], email: params[:email], pnumber: params[:pnumber], noid: params[:noid], gender: params[:gender])
			  			render json: @customer
				  	else
					  	render json: @customer.errors, status: :unprocessable_entity
  					end
	  			end
		  	end
      else
        head :no_content
      end
    else
		  if has_station?
        @station = Station.find_by(user_id: current_user.id)
  			@customer = Customer.find(params[:id])
	  		if @customer.station_id == @station.id
		  		if params.has_key?(:avatar)
			  		if @customer.update(customer_name: params[:customer_name], email: params[:email],address: params[:address], pnumber: params[:pnumber], noid: params[:noid], gender: params[:gender],avatar: params[:avatar])
              render json: @customer
					  else
						  render json: @customer.errors, status: :unprocessable_entity
  					end
	  			else
		  			if @customer.update(customer_name: params[:customer_name], email: params[:email],address: params[:address], pnumber: params[:pnumber], noid: params[:noid], gender: params[:gender])
			  			render json: @customer
				  	else
					  	render json: @customer.errors, status: :unprocessable_entity
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
	  		@customer = Customer.find(params[:id])
		  	if @customer.station_id == @station.id
			  	@customer.destroy
				  head :no_content
  			end
      end
    else
		  if has_station?
  			@station = Station.find_by(user_id: current_user.id)
	  		@customer = Customer.find(params[:id])
		  	if @customer.station_id == @station.id
			  	@customer.destroy
				  head :no_content
  			end
	  	else
		  	redirect_to root_path
  		end
	  end
	end


  def list
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 3
  			@station = Station.find params[:id_station]
	  		@data = []
		  	@data[0] = Customer.where(station_id: @station.id).order(updated_at: :desc)
			  @data[1] = Gender.all
  			render json: @data
      else
        head :no_content
      end
    else
		  if has_station?
  			@station = Station.find_by(user_id: current_user.id)
	  		@data = []
		  	@data[0] = Customer.where(station_id: @station.id).order(updated_at: :desc)
			  @data[1] = Gender.all
  			render json: @data
	  	else
        redirect_to root_path
      end
	  end
	end

  def activate
		if params.has_key?(:token)
			@customer = Customer.find_by(activation_digest: params[:token])
			if @customer != nil
				@customer.activate(@customer)
				render json: @customer
			else
				redirect_to root_path
			end
		else
			redirect_to root_path
		end
	end

  def find_record
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 4
        @station = Station.find params[:id_station]
  			if params.has_key?(:email)
	  			@doctor = User.find_by(email: params[:email])
		  		if @doctor != nil
			  		@profile = DoctorProfile.find_by(user_id: @doctor.id)
				  else
					  @profile = nil
  				end
	  			if @profile == nil
		  		  @record = nil
			  	else
				  	@record = Customer.find_by(user_id: @doctor.id, station_id: @station.id)
  			  end
	  		  @data = []
		  	  @data[0] = @profile
			    @data[1] = @record
			    if @doctor == nil
					  @data[2] = nil
  				else
	  				@data[2] = @doctor.id
		  	  end
			    render json: @data
  			end
      else
        head :no_content
      end
    else
		  if has_station?
        @station = Station.find_by(user_id: current_user.id)
  			if params.has_key?(:email)
	  			@doctor = User.find_by(email: params[:email])
		  		if @doctor != nil
			  		@profile = DoctorProfile.find_by(user_id: @doctor.id)
				  else
					  @profile = nil
  				end
	  			if @profile == nil
		  		  @record = nil
			  	else
				  	@record = Customer.find_by(user_id: @doctor.id, station_id: @station.id)
  			  end
	  		  @data = []
		  	  @data[0] = @profile
			    @data[1] = @record
			    if @doctor == nil
					  @data[2] = nil
  				else
	  				@data[2] = @doctor.id
		  	  end
			    render json: @data
  			end
      else
        redirect_to root_path
  		end
	  end
	end

  def add_record
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 1
			  @station = Station.find params[:id_station]
  			if params.has_key?(:id)
	  			@customeruser = User.find(params[:id])
		  		if @customeruser != nil
			  		@profile = DoctorProfile.find_by(user_id: @customeruser.id)
				  	if @profile != nil
					    @record = Customer.find_by(user_id: params[:id], station_id: @station.id)
				      if @record == nil
					      @record = Customer.new(user_id: @customeruser.id, station_id: @station.id, ename: @profile.lname + " " + @profile.fname, gender: @profile.gender, country: @profile.country, city: @profile.city, province: @profile.province, address: @profile.address, pnumber: @profile.pnumber, noid: @profile.noid, avatar: @profile.avatar)
  							if @record.save
	  							render json: @record
		  					else
			  					render json: @record.errors, status: :unprocessable_entity
				  			end
					  	end
  				  end
	  			end
		  	end
  	  else
        head :no_content
      end
    else
		  if has_station?
			  @station = Station.find_by(user_id: current_user.id)
  			if params.has_key?(:id)
	  			@customeruser = User.find(params[:id])
		  		if @customeruser != nil
			  		@profile = DoctorProfile.find_by(user_id: @customeruser.id)
				  	if @profile != nil
					    @record = Customer.find_by(user_id: params[:id], station_id: @station.id)
				      if @record == nil
					      @record = Customer.new(user_id: @customeruser.id, station_id: @station.id, ename: @profile.lname + " " + @profile.fname, gender: @profile.gender, country: @profile.country, city: @profile.city, province: @profile.province, address: @profile.address, pnumber: @profile.pnumber, noid: @profile.noid, avatar: @profile.avatar)
  							if @record.save
	  							render json: @record
		  					else
			  					render json: @record.errors, status: :unprocessable_entity
				  			end
					  	end
  				  end
	  			end
		  	end
  	  else
	  		redirect_to root_path
		  end
	  end
	end

	def link_record
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 2
	  		@station = Station.find params[:id_station]
		  	if params.has_key?(:id) && params.has_key?(:idrecord)
			  	@customeruser = User.find(params[:id])
				  if @customeruser != nil
					  @record = Customer.find_by(id: params[:idrecord], user_id: nil, station_id: @station.id)
  				  if @record != nil
	  				  if @record.update(user_id: @customeruser.id)
		  					render json: @record
			  			else
				  			render json: @record.errors, status: :unprocessable_entity
					  	end
  				  end
	  			end
		  	end
  	  else
        head :no_content
      end
    else
  		if has_station?
	  		@station = Station.find_by(user_id: current_user.id)
		  	if params.has_key?(:id) && params.has_key?(:idrecord)
			  	@customeruser = User.find(params[:id])
				  if @customeruser != nil
					  @record = Customer.find_by(id: params[:idrecord], user_id: nil, station_id: @station.id)
  				  if @record != nil
	  				  if @record.update(user_id: @customeruser.id)
		  					render json: @record
			  			else
				  			render json: @record.errors, status: :unprocessable_entity
					  	end
  				  end
	  			end
		  	end
  	  else
	  		redirect_to root_path
		  end
	  end
	end

	def clear_link_record
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 2
			  @station = Station.find params[:id_station]
			  if params.has_key?(:idrecord)
  				@record = Customer.find_by(id: params[:idrecord], station_id: @station.id)
	  			if @record != nil
		  		  if @record.update(user_id: nil)
			  			render json: @record
				  	else
					  	render json: @record.errors, status: :unprocessable_entity
  					end
	  			end
		  	end
  	  else
	  		head :no_content
      end
    else
		  if has_station?
			  @station = Station.find_by(user_id: current_user.id)
			  if params.has_key?(:idrecord)
  				@record = Customer.find_by(id: params[:idrecord], station_id: @station.id)
	  			if @record != nil
		  		  if @record.update(user_id: nil)
			  			render json: @record
				  	else
					  	render json: @record.errors, status: :unprocessable_entity
  					end
	  			end
		  	end
  	  else
	  		redirect_to root_path
		  end
  	end
	end

	def update_record
		if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 2
	  		@station = Station.find params[:id_station]
		  	if params.has_key?(:id) && params.has_key?(:idrecord)
			  	@customeruser = User.find(params[:id])
				  if @customeruser != nil
					  @profile = DoctorProfile.find_by(user_id: @customeruser.id)
  					if @profile != nil
	  					@record = Customer.find_by(id: params[:idrecord], user_id: @customeruser.id, station_id: @station.id)
		  				if @record != nil
			  		    if @record.update(user_id: @customeruser.id, station_id: @station.id, ename: @profile.lname + " " + @profile.fname, gender: @profile.gender, country: @profile.country, city: @profile.city, province: @profile.province, address: @profile.address, pnumber: @profile.pnumber, noid: @profile.noid, avatar: @profile.avatar)
				  			  render json: @record
					  	  else
						  	  render json: @record.errors, status: :unprocessable_entity
						    end
  					  end
	  			  end
		  		end
			  end
  	  else
        head :no_content
      end
    else
  		if has_station?
	  		@station = Station.find_by(user_id: current_user.id)
		  	if params.has_key?(:id) && params.has_key?(:idrecord)
			  	@customeruser = User.find(params[:id])
				  if @customeruser != nil
					  @profile = DoctorProfile.find_by(user_id: @customeruser.id)
  					if @profile != nil
	  					@record = Customer.find_by(id: params[:idrecord], user_id: @customeruser.id, station_id: @station.id)
		  				if @record != nil
			  		    if @record.update(user_id: @customeruser.id, station_id: @station.id, ename: @profile.lname + " " + @profile.fname, gender: @profile.gender, country: @profile.country, city: @profile.city, province: @profile.province, address: @profile.address, pnumber: @profile.pnumber, noid: @profile.noid, avatar: @profile.avatar)
				  			  render json: @record
					  	  else
						  	  render json: @record.errors, status: :unprocessable_entity
						    end
  					  end
	  			  end
		  		end
			  end
  	  else
	  		redirect_to root_path
		  end
  	end
  end

  def search
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], params[:table_id], 4
        @station = Station.find params[:id_station]
        if params.has_key?(:customer_name)
          @supplier = Customer.where("customer_name LIKE ? and station_id = ?" , "%#{params[:customer_name]}%", @station.id).group(:customer_name).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Customer.where("address LIKE ? and station_id = ?" , "%#{params[:address]}%", @station.id).group(:address).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:noid)
					@supplier = Customer.where("noid LIKE ? and station_id = ?" , "%#{params[:noid]}%", @station.id).group(:noid).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:pnumber)
					@supplier = Customer.where("pnumber LIKE ? and station_id = ?" , "%#{params[:pnumber]}%", @station.id).group(:pnumber).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:email)
					@supplier = Customer.where("email LIKE ? and station_id = ?" , "%#{params[:email]}%", @station.id).group(:email).limit(5)
			    render json:@supplier
			  end
      else
        head :no_content
      end
    else
      if has_station?
        @station = Station.find_by(user_id: current_user.id)
        if params.has_key?(:customer_name)
          @supplier = Customer.where("customer_name LIKE ? and station_id = ?" , "%#{params[:customer_name]}%", @station.id).group(:customer_name).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Customer.where("address LIKE ? and station_id = ?" , "%#{params[:address]}%", @station.id).group(:address).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:noid)
					@supplier = Customer.where("noid LIKE ? and station_id = ?" , "%#{params[:noid]}%", @station.id).group(:noid).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:pnumber)
					@supplier = Customer.where("pnumber LIKE ? and station_id = ?" , "%#{params[:pnumber]}%", @station.id).group(:pnumber).limit(5)
			    render json:@supplier
			  elsif params.has_key?(:email)
					@supplier = Customer.where("email LIKE ? and station_id = ?" , "%#{params[:email]}%", @station.id).group(:email).limit(5)
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
          start = Customer.order(created_at: :asc).first.created_at
          fin = Time.now
        end
        if params.has_key?(:customer_name)
          @supplier = Customer.where(created_at: start..fin).where("customer_name LIKE ? and station_id = ?" , "%#{params[:customer_name]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Customer.where(created_at: start..fin).where("address LIKE ? and station_id = ?" , "%#{params[:address]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:noid)
					@supplier = Customer.where(created_at: start..fin).where("noid LIKE ? and station_id = ?" , "%#{params[:noid]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:pnumber)
					@supplier = Customer.where(created_at: start..fin).where("pnumber LIKE ? and station_id = ?" , "%#{params[:pnumber]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:gender)
					@supplier = Customer.where(created_at: start..fin).where("gender = ? and station_id = ?" , params[:gender], @station.id)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Customer.where(created_at: start..fin).where("email LIKE ? and station_id = ?" , "%#{params[:email]}%", @station.id)
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
          start = Customer.order(created_at: :asc).first.created_at
          fin = Time.now
        end
        if params.has_key?(:customer_name)
          @supplier = Customer.where(created_at: start..fin).where("customer_name LIKE ? and station_id = ?" , "%#{params[:customer_name]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:address)
					@supplier = Customer.where(created_at: start..fin).where("address LIKE ? and station_id = ?" , "%#{params[:address]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:noid)
					@supplier = Customer.where(created_at: start..fin).where("noid LIKE ? and station_id = ?" , "%#{params[:noid]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:pnumber)
					@supplier = Customer.where(created_at: start..fin).where("pnumber LIKE ? and station_id = ?" , "%#{params[:pnumber]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:gender)
					@supplier = Customer.where(created_at: start..fin).where("gender = ? and station_id = ?" , params[:gender], @station.id)
			    render json:@supplier
			  elsif params.has_key?(:email)
					@supplier = Customer.where(created_at: start..fin).where("email LIKE ? and station_id = ?" , "%#{params[:email]}%", @station.id)
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
