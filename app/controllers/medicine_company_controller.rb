class MedicineCompanyController < ApplicationController
  before_action :logged_in_user, only: [:list, :create, :update, :destroy, :search, :find]
  
  def list
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], 2, 4
			  @station = Station.find params[:id_station]
			  @data = []
        if params.has_key?(:date)
          n = params[:date].to_i
          start = n.days.ago.beginning_of_day
          fin = Time.now
          @data[0] = MedicineCompany.where(station_id: @station.id, created_at: start..fin)
          @data[1] = MedicineGroup.where(created_at: start..fin)
          @data[2] = MedicineType.where(created_at: start..fin)
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start = params[:begin_date].to_date.beginning_of_day
          fin = params[:end_date].to_date.end_of_day
          @data[0] = MedicineCompany.where(station_id: @station.id, created_at: start..fin)
          @data[1] = MedicineGroup.where(created_at: start..fin)
          @data[2] = MedicineType.where(created_at: start..fin)
        else
          @data[0] = MedicineCompany.where(station_id: @station.id)
          @data[1] = MedicineGroup.all
          @data[2] = MedicineType.all
        end
			  render json: @data
		  else
        head :no_content
      end
    else
      if has_station?
			  @station = Station.find_by(user_id: current_user.id)
			  @data = []
        if params.has_key?(:date)
          n = params[:date].to_i
          start = n.days.ago.beginning_of_day
          fin = Time.now
          @data[0] = MedicineCompany.where(station_id: @station.id, created_at: start..fin)
          @data[1] = MedicineGroup.where(created_at: start..fin)
          @data[2] = MedicineType.where(created_at: start..fin)
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start = params[:begin_date].to_date.beginning_of_day
          fin = params[:end_date].to_date.end_of_day
          @data[0] = MedicineCompany.where(station_id: @station.id, created_at: start..fin)
          @data[1] = MedicineGroup.where(created_at: start..fin)
          @data[2] = MedicineType.where(created_at: start..fin)
        else
          @data[0] = MedicineCompany.where(station_id: @station.id)
          @data[1] = MedicineGroup.all
          @data[2] = MedicineType.all
        end
			  render json: @data
		  else
        redirect_to root_path
      end
    end
  end

  def create
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], 2, 1
			  @station = Station.find params[:id_station]
		    @supplier = MedicineCompany.new(station_id: @station.id, name: params[:name], address: params[:address], pnumber: params[:pnumber], noid: params[:noid], email: params[:email], website: params[:website], taxcode: params[:taxcode])
				if @supplier.save
				  render json: @supplier
				else
					render json: @supplier.errors, status: :unprocessable_entity
				end
		  else
        head :no_content
      end
    else
      if has_station?
			  @station = Station.find_by(user_id: current_user.id)
		    @supplier = MedicineCompany.new(station_id: @station.id, name: params[:name], address: params[:address], pnumber: params[:pnumber], noid: params[:noid], email: params[:email], website: params[:website], taxcode: params[:taxcode])
				if @supplier.save
				  render json: @supplier
				else
					render json: @supplier.errors, status: :unprocessable_entity
				end
		  else
        redirect_to root_path
      end
    end
  end

  def update
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], 2, 2
        @station = Station.find params[:id_station]
        if params.has_key?(:id)
          @supplier = MedicineCompany.find(params[:id])
			    if @supplier.station_id == @station.id
            if @supplier.update(name: params[:name], address: params[:address], pnumber: params[:pnumber], noid: params[:noid], email: params[:email], website: params[:website], taxcode: params[:taxcode])
				      render json: @supplier
				    else
				      render json: @supplier.errors, status: :unprocessable_entity
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
          @supplier = MedicineCompany.find(params[:id])
			    if @supplier.station_id == @station.id
            if @supplier.update(name: params[:name], address: params[:address], pnumber: params[:pnumber], noid: params[:noid], email: params[:email], website: params[:website], taxcode: params[:taxcode])
				      render json: @supplier
				    else
				      render json: @supplier.errors, status: :unprocessable_entity
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
      if current_user.check_permission params[:id_station], 2, 4
        @station = Station.find params[:id_station]
        if params.has_key?(:noid)
          @supplier = MedicineCompany.where("noid LIKE ? and station_id = ?" , "%#{params[:noid]}%", @station.id).group(:noid).limit(3)
			    render json:@supplier
        elsif params.has_key?(:name)
				  @supplier = MedicineCompany.where("name LIKE ? and station_id = ?" , "%#{params[:name]}%", @station.id).group(:name).limit(3)
			    render json:@supplier
			  elsif params.has_key?(:pnumber)
				  @supplier = MedicineCompany.where("pnumber LIKE ? and station_id = ?" , "%#{params[:pnumber]}%", @station.id).group(:pnumber).limit(3)
			    render json:@supplier
				elsif params.has_key?(:address)
				  @supplier = MedicineCompany.where("address LIKE ? and station_id = ?" , "%#{params[:address]}%", @station.id).group(:address).limit(3)
			    render json:@supplier
				elsif params.has_key?(:email)
				  @supplier = MedicineCompany.where("email LIKE ? and station_id = ?" , "%#{params[:email]}%", @station.id).group(:email).limit(3)
			    render json:@supplier
				elsif params.has_key?(:website)
				  @supplier = MedicineCompany.where("website LIKE ? and station_id = ?" , "%#{params[:website]}%", @station.id).group(:website).limit(3)
			    render json:@supplier
				elsif params.has_key?(:taxcode)
				  @supplier = MedicineCompany.where("taxcode LIKE ? and station_id = ?" , "%#{params[:taxcode]}%", @station.id).group(:taxcode).limit(3)
			    render json:@supplier
				end
      else
        head :no_content
      end
    else
      if has_station?
        @station = Station.find_by(user_id: current_user.id)
        if params.has_key?(:noid)
          @supplier = MedicineCompany.where("noid LIKE ? and station_id = ?" , "%#{params[:noid]}%", @station.id).group(:noid).limit(3)
			    render json:@supplier
        elsif params.has_key?(:name)
				  @supplier = MedicineCompany.where("name LIKE ? and station_id = ?" , "%#{params[:name]}%", @station.id).group(:name).limit(3)
			    render json:@supplier
			  elsif params.has_key?(:pnumber)
				  @supplier = MedicineCompany.where("pnumber LIKE ? and station_id = ?" , "%#{params[:pnumber]}%", @station.id).group(:pnumber).limit(3)
			    render json:@supplier
				elsif params.has_key?(:address)
				  @supplier = MedicineCompany.where("address LIKE ? and station_id = ?" , "%#{params[:address]}%", @station.id).group(:address).limit(3)
			    render json:@supplier
				elsif params.has_key?(:email)
				  @supplier = MedicineCompany.where("email LIKE ? and station_id = ?" , "%#{params[:email]}%", @station.id).group(:email).limit(3)
			    render json:@supplier
				elsif params.has_key?(:website)
				  @supplier = MedicineCompany.where("website LIKE ? and station_id = ?" , "%#{params[:website]}%", @station.id).group(:website).limit(3)
			    render json:@supplier
				elsif params.has_key?(:taxcode)
				  @supplier = MedicineCompany.where("taxcode LIKE ? and station_id = ?" , "%#{params[:taxcode]}%", @station.id).group(:taxcode).limit(3)
			    render json:@supplier
				end
      else
        redirect_to root_path
      end
    end
  end

  def find
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], 2, 4
        @station = Station.find params[:id_station]
        if params.has_key?(:date)
          n = params[:date].to_i
          start = n.days.ago.beginning_of_day
          fin = Time.now
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start = params[:begin_date].to_date.beginning_of_day
          fin = params[:end_date].to_date.beginning_of_day
        else
          start = MedicineCompany.order(created_at: :asc).first.created_at
          fin = Time.now
        end
        if params.has_key?(:noid)
          @supplier = MedicineCompany.where(created_at: start..fin).where("noid LIKE ? and station_id = ?" , "%#{params[:noid]}%", @station.id)
			    render json:@supplier
        elsif params.has_key?(:name)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("name LIKE ? and station_id = ?" , "%#{params[:name]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:pnumber)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("pnumber LIKE ? and station_id = ?" , "%#{params[:pnumber]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:address)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("address LIKE ? and station_id = ?" , "%#{params[:address]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:email)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("email LIKE ? and station_id = ?" , "%#{params[:email]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:website)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("website LIKE ? and station_id = ?" , "%#{params[:website]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:taxcode)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("taxcode LIKE ? and station_id = ?" , "%#{params[:taxcode]}%", @station.id)
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
          fin = params[:end_date].to_date.beginning_of_day
        else
          start = MedicineCompany.order(created_at: :asc).first.created_at
          fin = Time.now
        end
        if params.has_key?(:noid)
          @supplier = MedicineCompany.where(created_at: start..fin).where("noid LIKE ? and station_id = ?" , "%#{params[:noid]}%", @station.id)
			    render json:@supplier
        elsif params.has_key?(:name)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("name LIKE ? and station_id = ?" , "%#{params[:name]}%", @station.id)
			    render json:@supplier
			  elsif params.has_key?(:pnumber)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("pnumber LIKE ? and station_id = ?" , "%#{params[:pnumber]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:address)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("address LIKE ? and station_id = ?" , "%#{params[:address]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:email)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("email LIKE ? and station_id = ?" , "%#{params[:email]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:website)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("website LIKE ? and station_id = ?" , "%#{params[:website]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:taxcode)
				  @supplier = MedicineCompany.where(created_at: start..fin).where("taxcode LIKE ? and station_id = ?" , "%#{params[:taxcode]}%", @station.id)
			    render json:@supplier
				end
      else
        redirect_to root_path
      end
    end
  end

  def destroy
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], 2, 3
			  @station = Station.find params[:id_station]
			  if params.has_key?(:id)
			    @supplier = MedicineCompany.find(params[:id])
			    if @supplier.station_id == @station.id
				    @supplier.destroy
				    head :no_content
			    end
			  end
      end
    else
      if has_station?
			  @station = Station.find_by(user_id: current_user.id)
			  if params.has_key?(:id)
			    @supplier = MedicineCompany.find(params[:id])
			    if @supplier.station_id == @station.id
				    @supplier.destroy
				    head :no_content
			    end
			  end
		  else
			  redirect_to root_path
		  end
    end
  end
end
