class AuthSerializer < ActiveModel::Serializer
  # byebug
  attributes :message, :token, :user

  def message
    # puts(:message)
    @instance_options[:message]
  end

  def token
    # puts(:token)
    @instance_options[:token]
  end

  def user
    # puts(:user)
    UserSerializer.new(object).as_json
  end
end
