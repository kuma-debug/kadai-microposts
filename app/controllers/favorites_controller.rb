class FavoritesController < ApplicationController
  def create
#   render plain: params.inspect
    micropost = Micropost.find(params[:micropost_id])
    current_user.set_favorite(micropost)
    flash[:success] = 'お気に入りに追加しました。'
    redirect_to root_url
  end

  def destroy
    micropost = Micropost.find(params[:micropost_id])
    current_user.unset_favorite(micropost)
    flash[:success] = 'お気に入りから削除しました。'
    redirect_to root_url
  end
end