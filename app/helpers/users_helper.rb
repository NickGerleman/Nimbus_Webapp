module UsersHelper
  def gravatar(user)
    id = Digest::MD5.hexdigest(user.email)
   "http://gravatar.com/avatar/#{id}?s=200?d=mm?r=pg"
  end

end
