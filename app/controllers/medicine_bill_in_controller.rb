class MedicineBillInController < ApplicationController
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
          @data[0] = MedicineBillIn.where(station_id: @station.id, created_at: start..fin)
          @data[1] = MedicineGroup.where(created_at: start..fin)
          @data[2] = MedicineType.where(created_at: start..fin)
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start = params[:begin_date].to_date.beginning_of_day
          fin = params[:end_date].to_date.end_of_day
          @data[0] = MedicineBillIn.where(station_id: @station.id, created_at: start..fin)
          @data[1] = MedicineGroup.where(created_at: start..fin)
          @data[2] = MedicineType.where(created_at: start..fin)
        else
          @data[0] = MedicineBillIn.where(station_id: @station.id)
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
          @data[0] = MedicineBillIn.where(station_id: @station.id, created_at: start..fin)
          @data[1] = MedicineGroup.where(created_at: start..fin)
          @data[2] = MedicineType.where(created_at: start..fin)
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start = params[:begin_date].to_date.beginning_of_day
          fin = params[:end_date].to_date.end_of_day
          @data[0] = MedicineBillIn.where(station_id: @station.id, created_at: start..fin)
          @data[1] = MedicineGroup.where(created_at: start..fin)
          @data[2] = MedicineType.where(created_at: start..fin)
        else
          @data[0] = MedicineBillIn.where(station_id: @station.id)
          @data[1] = MedicineGroup.all
          @data[2] = MedicineType.all
        end
			  render json: @data
		  else
        redirect_to root_path
      end
    end
  end

  def summary
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], 2, 4
        @station = Station.find params[:id_station]
        @data = []
        if params.has_key?(:date)
          n = params[:date].to_i
          start_date = n.days.ago.to_date
          end_date = Time.now.to_date + 1
          @data[0] = MedicineBillIn.sum_payout start_date, end_date, @station.id
          render json: @data
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start_date = params[:begin_date].to_date
          end_date = params[:end_date].to_date.end_of_day.strftime("%Y-%m-%d %H:%M:%S")
          @data[0] = MedicineBillIn.sum_payout start_date, end_date, @station.id
          render json: @data
        else
          redirect_to root_path
        end
      else
        head :no_content
      end
    else
      if has_station?
        @station = Station.find_by(user_id: current_user.id)
        @data = []
        if params.has_key?(:date)
          n = params[:date].to_i
          start_date = n.days.ago.to_date
          end_date = Time.now.to_date + 1
          @data[0] = MedicineBillIn.sum_payout start_date, end_date, @station.id
          render json: @data
        elsif params.has_key?(:begin_date) && params.has_key?(:end_date)
          start_date = params[:begin_date].to_date
          end_date = params[:end_date].to_date.end_of_day.strftime("%Y-%m-%d %H:%M:%S")
          @data[0] = MedicineBillIn.sum_payout start_date, end_date, @station.id
          render json: @data
        else
          redirect_to root_path
        end
      end
    end
  end

  def create
    if params.has_key?(:id_station)
      if current_user.check_permission params[:id_station], 2, 1
				@station = Station.find params[:id_station]
			  @supplier_id = MedicineSupplier.find_by(id: params[:supplier_id], name: params[:supplier], station_id: @station.id)
		    if !@supplier_id.nil?
				  @supplier_id = @supplier_id.id
		    end
		    @billin = MedicineBillIn.new(station_id: @station.id, supplier_id: @supplier_id, billcode: params[:billcode], 
                                       dayin: params[:dayin], supplier: params[:supplier], daybook: params[:daybook], 
                                       pmethod: params[:pmethod], tpayment: params[:tpayment], discount: params[:discount], 
                                       tpayout: params[:tpayout], remark: params[:remark], status: params[:status])
				if @billin.save
					for bill_record in JSON.parse(params[:list_bill_record]) do
            @sample_id = MedicineSample.find_by(id: bill_record["sample_id"], name: bill_record["name"], station_id: @station.id)
		        if !@sample_id.nil?
				      @sample_id = @sample_id.id
		        end
            @company_id = MedicineCompany.find_by(id: bill_record["company_id"], name: bill_record["company"], station_id: @station.id)
		        if !@company_id.nil?
				      @company_id = @company_id.id
		        end
            @billrecord = MedicineBillRecord.new(station_id: @station.id, bill_id: @billin.id, billcode: @billin.billcode,
                                                 name: bill_record["name"], company: bill_record["company"], company_id: @company_id,
                                                 sample_id: @sample_id, noid: bill_record["noid"], signid: bill_record["signid"],
                                                 expire: bill_record["expire"], pmethod: bill_record["pmethod"],
                                                 qty: bill_record["qty"], taxrate: bill_record["taxrate"],
                                                 price: bill_record["price"], remark: bill_record["remark"])
            @billrecord.save
            if @billin.discount.present?
              discount = @billin.discount * ((@billrecord.price * @billrecord.qty).to_f / @billin.tpayment)
              @billrecord.update(discount: discount.to_i)
            end
            if @billin.status
              type = @billin.status
            else
              type = 1
            end
            MedicineStockRecord.create(station_id: @station.id, name: bill_record["name"], noid: bill_record["noid"], 
              supplier: @billin.supplier, signid: bill_record["signid"], amount: bill_record["qty"], expire: bill_record["expire"], 
              supplier_id: @billin.supplier_id, bill_in_id: @billin.id, bill_in_code: @billin.billcode, 
              typerecord: type, sample_id: @sample_id)
          end
				  render json: @billin
				else
					render json: @billin.errors, status: :unprocessable_entity
				end
		  else
        head :no_content
      end
    else
      if has_station?
				@station = Station.find_by(user_id: current_user.id)
			  @supplier_id = MedicineSupplier.find_by(id: params[:supplier_id], name: params[:supplier], station_id: @station.id)
		    if !@supplier_id.nil?
				  @supplier_id = @supplier_id.id
		    end
		    @billin = MedicineBillIn.new(station_id: @station.id, supplier_id: @supplier_id, billcode: params[:billcode], 
                                       dayin: params[:dayin], supplier: params[:supplier], daybook: params[:daybook], 
                                       pmethod: params[:pmethod], tpayment: params[:tpayment], discount: params[:discount], 
                                       tpayout: params[:tpayout], remark: params[:remark], status: params[:status])
				if @billin.save
					for bill_record in JSON.parse(params[:list_bill_record]) do
            @sample_id = MedicineSample.find_by(id: bill_record["sample_id"], name: bill_record["name"], station_id: @station.id)
		        if !@sample_id.nil?
				      @sample_id = @sample_id.id
		        end
            @company_id = MedicineCompany.find_by(id: bill_record["company_id"], name: bill_record["company"], station_id: @station.id)
		        if !@company_id.nil?
				      @company_id = @company_id.id
		        end
            @billrecord = MedicineBillRecord.new(station_id: @station.id, bill_id: @billin.id, billcode: @billin.billcode,
                                                 name: bill_record["name"], company: bill_record["company"], company_id: @company_id,
                                                 sample_id: @sample_id, noid: bill_record["noid"], signid: bill_record["signid"],
                                                 expire: bill_record["expire"], pmethod: bill_record["pmethod"],
                                                 qty: bill_record["qty"], taxrate: bill_record["taxrate"],
                                                 price: bill_record["price"], remark: bill_record["remark"])
            @billrecord.save
            if @billin.discount.present?
              discount = @billin.discount * ((@billrecord.price * @billrecord.qty).to_f / @billin.tpayment)
              @billrecord.update(discount: discount.to_i)
            end
            if @billin.status
              type = @billin.status
            else
              type = 1
            end
            MedicineStockRecord.create(station_id: @station.id, name: bill_record["name"], noid: bill_record["noid"], 
              supplier: @billin.supplier, signid: bill_record["signid"], amount: bill_record["qty"], expire: bill_record["expire"], 
              supplier_id: @billin.supplier_id, bill_in_id: @billin.id, bill_in_code: @billin.billcode, 
              typerecord: type, sample_id: @sample_id)
          end
				  render json: @billin
				else
					render json: @billin.errors, status: :unprocessable_entity
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
          @billin = MedicineBillIn.find(params[:id])
			    if @billin.station_id == @station.id
            @supplier_id = MedicineSupplier.find_by(id: params[:supplier_id], name: params[:supplier], station_id: @station.id)
		        if !@supplier_id.nil?
				      @supplier_id = @supplier_id.id
		        end
            if @billin.update(billcode: params[:billcode], dayin: params[:dayin], supplier: params[:supplier], 
                                daybook: params[:daybook], pmethod: params[:pmethod], tpayment: params[:tpayment], 
                                discount: params[:discount], tpayout: params[:tpayout], remark: params[:remark], 
                                status: params[:status])
              status = @billin.status
              @stockrecord = MedicineStockRecord.find_by(bill_in_id: @billin.id)
              if @stockrecord
                @stockrecord.update(typerecord: status)
              end
              for bill_record in JSON.parse(params[:list_bill_record]) do
								if !bill_record["created_at"].present?
									@sample_id = MedicineSample.find_by(id: bill_record["sample_id"], name: bill_record["name"], station_id: @station.id)
									if !@sample_id.nil?
										@sample_id = @sample_id.id
									end
									@company_id = MedicineCompany.find_by(id: bill_record["company_id"], name: bill_record["company"], station_id: @station.id)
									if !@company_id.nil?
										@company_id = @company_id.id
									end
									@billrecord = MedicineBillRecord.new(station_id: @station.id, bill_id: @billin.id, billcode: @billin.billcode,
																											 name: bill_record["name"], company: bill_record["company"], company_id: @company_id,
																											 sample_id: @sample_id, noid: bill_record["noid"], signid: bill_record["signid"],
																											 expire: bill_record["expire"], pmethod: bill_record["pmethod"],
																											 qty: bill_record["qty"], taxrate: bill_record["taxrate"],
																											 price: bill_record["price"], remark: bill_record["remark"])
									@billrecord.save
									if @billin.discount.present?
										discount = @billin.discount * ((@billrecord.price * @billrecord.qty).to_f / @billin.tpayment)
										@billrecord.update(discount: discount.to_i)
									end
									if @billin.status
										type = @billin.status
									else
										type = 1
									end
									MedicineStockRecord.create(station_id: @station.id, name: bill_record["name"], noid: bill_record["noid"], 
										supplier: @billin.supplier, signid: bill_record["signid"], amount: bill_record["qty"], expire: bill_record["expire"], 
										supplier_id: @billin.supplier_id, bill_in_id: @billin.id, bill_in_code: @billin.billcode, 
										typerecord: type, sample_id: @sample_id)
								end
							end
				      render json: @billin
				    else
				      render json: @billin.errors, status: :unprocessable_entity
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
          @billin = MedicineBillIn.find(params[:id])
			    if @billin.station_id == @station.id
            @supplier_id = MedicineSupplier.find_by(id: params[:supplier_id], name: params[:supplier], station_id: @station.id)
		        if !@supplier_id.nil?
				      @supplier_id = @supplier_id.id
		        end
            if @billin.update(billcode: params[:billcode], dayin: params[:dayin], supplier: params[:supplier], 
                                daybook: params[:daybook], pmethod: params[:pmethod], tpayment: params[:tpayment], 
                                discount: params[:discount], tpayout: params[:tpayout], remark: params[:remark], 
                                status: params[:status])
              status = @billin.status
              @stockrecord = MedicineStockRecord.find_by(bill_in_id: @billin.id)
              if @stockrecord
                @stockrecord.update(typerecord: status)
              end
              for bill_record in JSON.parse(params[:list_bill_record]) do
								if !bill_record["created_at"].present?
									@sample_id = MedicineSample.find_by(id: bill_record["sample_id"], name: bill_record["name"], station_id: @station.id)
									if !@sample_id.nil?
										@sample_id = @sample_id.id
									end
									@company_id = MedicineCompany.find_by(id: bill_record["company_id"], name: bill_record["company"], station_id: @station.id)
									if !@company_id.nil?
										@company_id = @company_id.id
									end
									@billrecord = MedicineBillRecord.new(station_id: @station.id, bill_id: @billin.id, billcode: @billin.billcode,
																											 name: bill_record["name"], company: bill_record["company"], company_id: @company_id,
																											 sample_id: @sample_id, noid: bill_record["noid"], signid: bill_record["signid"],
																											 expire: bill_record["expire"], pmethod: bill_record["pmethod"],
																											 qty: bill_record["qty"], taxrate: bill_record["taxrate"],
																											 price: bill_record["price"], remark: bill_record["remark"])
									@billrecord.save
									if @billin.discount.present?
										discount = @billin.discount * ((@billrecord.price * @billrecord.qty).to_f / @billin.tpayment)
										@billrecord.update(discount: discount.to_i)
									end
									if @billin.status
										type = @billin.status
									else
										type = 1
									end
									MedicineStockRecord.create(station_id: @station.id, name: bill_record["name"], noid: bill_record["noid"], 
										supplier: @billin.supplier, signid: bill_record["signid"], amount: bill_record["qty"], expire: bill_record["expire"], 
										supplier_id: @billin.supplier_id, bill_in_id: @billin.id, bill_in_code: @billin.billcode, 
										typerecord: type, sample_id: @sample_id)
								end
							end
				      render json: @billin
				    else
				      render json: @billin.errors, status: :unprocessable_entity
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
      if current_user.check_permission params[:id_station], 2, 3
			  @station = Station.find params[:id_station]
			  if params.has_key?(:id)
			    @billin = MedicineBillIn.find(params[:id])
			    if @billin.station_id == @station.id
				    @billin.destroy
				    MedicineBillRecord.where(:bill_id => @billin.id).destroy_all
				    MedicineStockRecord.where(:bill_in_id => @billin.id).destroy_all
				    head :no_content
			    end
			  end
		  else
        head :no_content
      end
    else
      if has_station?
			  @station = Station.find_by(user_id: current_user.id)
			  if params.has_key?(:id)
			    @billin = MedicineBillIn.find(params[:id])
			    if @billin.station_id == @station.id
				    @billin.destroy
				    MedicineBillRecord.where(:bill_id => @billin.id).destroy_all
				    MedicineStockRecord.where(:bill_in_id => @billin.id).destroy_all
				    head :no_content
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
        if params.has_key?(:billcode)
          @supplier = MedicineBillIn.where("billcode LIKE ? and station_id = ?" , "%#{params[:billcode]}%", @station.id).group(:billcode).limit(3)
			    render json:@supplier
        elsif params.has_key?(:supplier)
				  @supplier = MedicineBillIn.where("supplier LIKE ? and station_id = ?" , "%#{params[:supplier]}%", @station.id).group(:supplier).limit(3)
			    render json:@supplier
				elsif params.has_key?(:remark)
				  @supplier = MedicineBillIn.where("remark LIKE ? and station_id = ?" , "%#{params[:remark]}%", @station.id).group(:remark).limit(3)
			    render json:@supplier
			  end
      else
        head :no_content
      end
    else
      if has_station?
        @station = Station.find_by(user_id: current_user.id)
        if params.has_key?(:billcode)
          @supplier = MedicineBillIn.where("billcode LIKE ? and station_id = ?" , "%#{params[:billcode]}%", @station.id).group(:billcode).limit(3)
			    render json:@supplier
        elsif params.has_key?(:supplier)
				  @supplier = MedicineBillIn.where("supplier LIKE ? and station_id = ?" , "%#{params[:supplier]}%", @station.id).group(:supplier).limit(3)
			    render json:@supplier
				elsif params.has_key?(:remark)
				  @supplier = MedicineBillIn.where("remark LIKE ? and station_id = ?" , "%#{params[:remark]}%", @station.id).group(:remark).limit(3)
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
          fin = params[:end_date].to_date.end_of_day
        else
          start = MedicineBillIn.order(created_at: :asc).first.created_at
          fin = Time.now
        end
        if params.has_key?(:billcode)
          @supplier = MedicineBillIn.where(created_at: start..fin).where("billcode LIKE ? and station_id = ?" , "%#{params[:billcode]}%", @station.id)
			    render json:@supplier
        elsif params.has_key?(:dayin)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("dayin = ? and station_id = ?" , params[:dayin], @station.id)
			    render json:@supplier
        elsif params.has_key?(:supplier)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("supplier LIKE ? and station_id = ?" , "%#{params[:supplier]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:daybook)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("daybook = ? and station_id = ?" , params[:daybook], @station.id)
			    render json:@supplier
				elsif params.has_key?(:pmethod)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("pmethod = ? and station_id = ?" , params[:pmethod], @station.id)
			    render json:@supplier
				elsif params.has_key?(:tpayment)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("tpayment = ? and station_id = ?" , params[:tpayment], @station.id)
			    render json:@supplier
			  elsif params.has_key?(:discount)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("discount = ? and station_id = ?" , params[:discount], @station.id)
			    render json:@supplier
			  elsif params.has_key?(:tpayout)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("tpayout = ? and station_id = ?" , params[:tpayout], @station.id)
			    render json:@supplier
			  elsif params.has_key?(:status)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("status = ? and station_id = ?" , params[:status], @station.id)
			    render json:@supplier
				elsif params.has_key?(:remark)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("remark LIKE ? and station_id = ?" , "%#{params[:remark]}%", @station.id)
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
          start = MedicineBillIn.order(created_at: :asc).first.created_at
          fin = Time.now
        end
        if params.has_key?(:billcode)
          @supplier = MedicineBillIn.where(created_at: start..fin).where("billcode LIKE ? and station_id = ?" , "%#{params[:billcode]}%", @station.id)
			    render json:@supplier
        elsif params.has_key?(:dayin)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("dayin = ? and station_id = ?" , params[:dayin], @station.id)
			    render json:@supplier
        elsif params.has_key?(:supplier)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("supplier LIKE ? and station_id = ?" , "%#{params[:supplier]}%", @station.id)
			    render json:@supplier
				elsif params.has_key?(:daybook)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("daybook = ? and station_id = ?" , params[:daybook], @station.id)
			    render json:@supplier
				elsif params.has_key?(:pmethod)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("pmethod = ? and station_id = ?" , params[:pmethod], @station.id)
			    render json:@supplier
				elsif params.has_key?(:tpayment)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("tpayment = ? and station_id = ?" , params[:tpayment], @station.id)
			    render json:@supplier
			  elsif params.has_key?(:discount)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("discount = ? and station_id = ?" , params[:discount], @station.id)
			    render json:@supplier
			  elsif params.has_key?(:tpayout)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("tpayout = ? and station_id = ?" , params[:tpayout], @station.id)
			    render json:@supplier
			  elsif params.has_key?(:status)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("status = ? and station_id = ?" , params[:status], @station.id)
			    render json:@supplier
				elsif params.has_key?(:remark)
				  @supplier = MedicineBillIn.where(created_at: start..fin).where("remark LIKE ? and station_id = ?" , "%#{params[:remark]}%", @station.id)
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
