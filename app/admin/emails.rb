ActiveAdmin.register Email do
  permit_params :from, :to, :subject, :body, :incoming, :company_id, :date

  scope("Письма", show_count: true, default: true){ |scope| scope.company(current_user.company.id) }

  actions :all, except: [:new, :create, :update, :edit]

  filter :from
  filter :to
  filter :subject
  filter :body
  filter :incoming
  filter :date

  index title: "Письма" do
    column('От', :from)
    column('Кому', :to)
    column('Заголовок', :subject)
    column('Тело', :body)
    column('Входящее', :incoming)
    column('Дата', :date)
    actions
  end

  show do
    attributes_table do
      row('От', :from, &:from)
      row('Кому', :to, &:to)
      row('Заголовок', :subject, &:subject)
      row('Тело', :body, &:body)
      row('Входящее', :incoming, &:incoming)
      row('Дата', :date, &:date)
    end
  end
end
