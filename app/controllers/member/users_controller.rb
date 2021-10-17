# encoding: UTF-8
class Member::UsersController < Member::Base
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    if current_user
      redirect_to(user_path(current_user.name), :notice => '一つのログイン情報に一つを超えるユーザー情報は登録できません')
      return
    end

    @user = User.new(user_params)
    current_userauth.user = @user

    if @user.save
      current_userauth.save!
      redirect_to(user_path(@user.name), :notice => 'User was successfully created.')
    else
      render :action => "new"
    end
  end

  def update
    @user = User.find(params[:id])
    unless @user.id == current_user.id
      redirect_to(user_path(current_user.name), :notice => '他のユーザーは編集できません')
      return
    end

    @user.name.gsub!(/[\.\/]/, "")
    #params[:user].each{|k,v| params[:user][k].gsub!(/\/\./, "") if k == :name}

    if @user.update_attributes(user_params)
      redirect_to(user_path(@user.name), :notice => 'User was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to(users_path)
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :realname,
      :pcmail,
      :mbmail,
      :twitter,
      :url,
      :publicabout,
      :privateabout,
      :joined,
      :entered
    )
  end
end
