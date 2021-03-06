class Api::UsersController < ApiController
  before_action :authenticated?
  
  def create
    user = User.new(user_params)
    
    if user.save
      #When render :json is called, rails searches for a serializer and uses it if available.
      render json: user
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  def index
    users = User.all
    render json: users, each_serializer: UserSerializer
  end
  
  def destroy
    begin 
      user = User.find(params[:id])
      user.destroy
      
      render json: {}, status: :no_content
    rescue ActiveRecord::RecordNotFound
      render :json => {}, :status => :not_found
    end
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :password)
  end
end