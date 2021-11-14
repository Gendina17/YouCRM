ActiveAdmin.register_page 'Crm Info' do

  content title: 'Информация о YouCrm' do
    name = current_user.company.name
    count = Company.count
    render(partial: 'admin/crm_info/info', locals: { name: name, count: count })
  end
end
