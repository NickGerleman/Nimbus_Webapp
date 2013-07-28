class UserSerializer < ActiveModel::Serializer
  cached
  delegate :cache_key, to: :object

  self.root = false
  attributes :name, :id, :socket_token
  has_many :connections, embed: :id

  def connections
    object.connections.where(state: 'success')
  end
end
