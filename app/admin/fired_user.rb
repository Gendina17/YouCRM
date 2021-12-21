ActiveAdmin.register_page 'Fired User' do

  content title: 'Уволить пользователя' do
    users = User.company(current_user.company.id).not_fired.
      map{ |user| [user.full_name, user.id] }.to_h
    render(partial: 'admin/fired_user/fired', locals: { users: users })
  end

  page_action :fired, method: :post do
    flash[:error] = 'Выберите пользователя' and return redirect_to admin_fired_user_path if params[:user_id].blank?
    User.find(params[:user_id]).update(is_fired: true)
    flash[:notice] = "Пользователь уволен"
    redirect_to admin_fired_user_path
  end
end

