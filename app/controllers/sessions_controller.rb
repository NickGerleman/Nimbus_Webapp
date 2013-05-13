class SessionsController < ApplicationController
  def create
    respond_to do |format|
      user = User.find_by_email params[:email]
      if user and user.authenticate params[:password]

      else
        flash.now[:errors] = true
        format.js
      end
    end
  end

  def destroy

  end
end
