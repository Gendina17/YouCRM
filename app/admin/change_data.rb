ActiveAdmin.register_page 'Change Data' do

  content title: 'Изменить данные почты' do
    @company = current_user.company
    render(partial: 'admin/change_data/data', locals: {company: @company})
  end

  page_action :data, method: :post do
    current_user.company.update(params.permit(:email, :is_send))
    current_user.company.password = ApplicationController.new.crypt.encrypt_and_sign(params[:password])

    if current_user.company.save! 
      flash[:notice] = "Данные почты изменены"
    else
      flash[:error] = "Что-то пошло не так"
    end
    redirect_to admin_change_data_path
  end
end
