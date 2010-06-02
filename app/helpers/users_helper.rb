module UsersHelper
  #
  # @return A map where key: username, value: user id.
  #
  def available_users
    users= Hash.new
    User.find(:all).each do |u|
      users[u.name]= u.id
    end
    users
  end
end
