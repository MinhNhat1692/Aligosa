class SaleProfileController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :show, :update]
  
  def new
    if has_sale_profile?
			@sale_profile = SaleProfile.find_by(user_id: current_user.id)
			render 'show'
		else
      if has_profile?
        @pro = Profile.find_by(user_id: current_user.id)
      else
        @pro = Profile.new
      end
      @sale_profile = SaleProfile.new
    end
  end

  def create
    if has_sale_profile?
			@sale_profile = SaleProfile.find_by(user_id: current_user.id)
			render 'show'
		else
			@sale_profile = SaleProfile.new(user_id: current_user.id, fname: params[:sale_profile][:fname], lname: params[:sale_profile][:lname], dob: params[:sale_profile][:dob], gender: params[:sale_profile][:gender], address: params[:sale_profile][:address], email: params[:sale_profile][:email], pnumber: params[:sale_profile][:pnumber], noid: params[:sale_profile][:noid], issue_date: params[:sale_profile][:issue_date], issue_place: params[:sale_profile][:issue_place], avatar: params[:sale_profile][:avatar])
			if @sale_profile.save
				@sprofile = @sale_profile
				render 'show'
			else
				render 'new'
			end
    end
  end

  def update
		if has_sale_profile?
      @sale_profile = SaleProfile.find_by(user_id: current_user.id)
			if params.has_key?(:avatar)
				if @sale_profile.update(fname: params[:fname],lname: params[:lname], dob: params[:dob], noid: params[:noid], address: params[:address], email: params[:email], avatar: params[:avatar], issue_date: params[:issue_date], issue_place: params[:issue_place], pnumber: params[:pnumber])
					render json: @sale_profile
				else
					render json: @sale_profile.errors, status: :unprocessable_entity
				end
			else
				if @sale_profile.update(fname: params[:fname],lname: params[:lname], dob: params[:dob], noid: params[:noid], address: params[:address], email: params[:email], issue_date: params[:issue_date], issue_place: params[:issue_place], pnumber: params[:pnumber])
					render json: @sale_profile
				else
					render json: @sale_profile.errors, status: :unprocessable_entity
				end
			end
    else
      head :no_content
    end
  end

  def show
		@sale_profile = SaleProfile.find_by(user_id: current_user.id)
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
