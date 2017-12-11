defmodule DealiefWeb.ControllerHelper do

  def generate_user_token(user_id) do
    Phoenix.Token.sign(DealiefWeb.Endpoint, "user_token", user_id)  
  end

  @max_age 86400 # 1 day
  def verify_user_token(token) do
    Phoenix.Token.verify(DealiefWeb.Endpoint, "user_token", token, max_age: @max_age)
  end
    
end