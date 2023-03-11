class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update]
  before_action :authorize, only: [:show, :update]

  # SHOW LIST (ko can cho user, neu can dung cho admin cung dc, de check thoi)
  def index
    @users = User.all
    render json: @users,  status: 200
  end

  # SHOW EACH INFO
  def show
    render json: { user: @user},  status: 200
  end

  # NEW/ SIGNUP
  def create
    @user = User.create(user_params)

    if @user.valid?
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token},  status: 200 #:ok
    else
      render json: { error: 'Invalid username or password' }, status: 422 #:unprocessable_entity
    end
  end

  #LOGIN
  def login
    @user = User.find_by(nickname: user_params[:nickname])
    if @user && @user.authenticate(user_params[:password])
      token = encode_token({ user_id: @user.id })
      render json: { user: @user, token: token }, status: 200
    else
      render json: { error: 'Invalid username or password' }, status: 422
    end
  end


  # UPDATE
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: 422
    end
  end




  private
  def user_params
    params.require(:user).permit(:nickname, :password, :email)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
end
