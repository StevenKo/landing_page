# coding: utf-8 
class WelcomeController < ApplicationController
  def index
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.password = "111111"
    if @user.save
      flash[:notice] = "成功留下 E-mail 囉！ 謝謝你，我們會好好努力的！"
      redirect_to :action => :index
    else
      flash[:alert] = "系統出了問題，麻煩再試一次，如果還是不行，我們會趕緊修正，謝謝！#{@user.errors.full_messages}" 
      redirect_to :action => :index
    end
  end
end
