class EmailAddressesController < ApplicationController

  force_ssl if Rails.env.production?

  def edit
    render partial: 'edit', layout: false
  end

  def update
    @user = current_user
    @user.update_attributes(user_params)
  end

  private

  def user_params
    params.require(:user).permit(:email, :email_confirmation)
  end

end
