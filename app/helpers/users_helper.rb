module UsersHelper

  def gravatar
    id = Digest::MD5.hexdigest(current_user.email)
   "http://gravatar.com/avatar/#{id}?s=200&d=mm&r=pg"
  end
end
