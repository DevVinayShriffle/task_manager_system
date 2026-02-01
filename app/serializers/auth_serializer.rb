class AuthSerializer < ActiveModel::Serializer
  attributes :message, :token, :user

  def message
    instance_options[:message]
  end

  def token
    instance_options[:token]
  end

  def user
    UserSerializer.new(object).as_json
  end
end
