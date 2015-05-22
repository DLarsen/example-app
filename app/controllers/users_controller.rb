class UsersController < ApplicationController
  before_action :authenticate_admin!

	def index
    @total_users = User.count
		@users = User.select(:id,:name).includes(items: [:categories]).limit(20).offset(offset)
    respond_to do |format|
      format.html
      format.json
    end
	end

  def show
    @user = User.includes(items: [:categories]).find(params[:id])
  end

  private
    def offset
      (params[:offset] || 0).to_i
    end

end