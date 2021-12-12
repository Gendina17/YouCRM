require 'application_system_test_case'

class MainTest < ApplicationSystemTestCase
  setup do
    @company = Company.create!(name: 'First')
    role = Role.create!(name: 'Admin', company: @company)
    @user = User.create!(name: 'Нина', surname: 'Гендина', company_id: @company.id,
        email: 'gnb@mail.ru', password: '123456', role_id: role.id )
    @user.update(email_confirmed: true)
    @company.update(type_client: 'human')
    @company.update(type_product: 'product')
    @ticket = Ticket.create!(subject: 'LOLLUL', company_id: @company.id, client: Client.last, is_closed: false)

    visit root_url
    click_on 'Авторизоваться'
    fill_in 'company', with: @company.name
    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password
    click_on 'Войти'
    visit root_url
  end

  test 'test_create_ticket' do
    Client.create!(name: 'nina', company: @company)
    click_link title: "Создать новый тикет"
    fill_in 'subject', with: 'FirstTicket'
    fill_in 'description', with: 'Это самый лучший тикет'
    fill_in 'client', with: 'uygy@ddd.ru'
    click_button title: 'Создать тикет'
    assert_text 'Нина Гендина'
  end

  test 'test_create_client' do
    click_link title: "Создать нового клиента"
    fill_in 'name', with: 'Nina'
    fill_in 'surname', with: 'Gendina'
    click_on 'Создать клиента'
    assert_text 'Нина Гендина'
  end

  test 'test_log_exist' do
    find('.ticket').click
    assert_text 'crm создал(а) тикет'
  end

  test 'test_create_note' do
    find('.ticket').click
    fill_in 'body', with: 'Всем привет! Как дела?'
    click_button title: 'Отпрвить'
    click_on 'Заметки'
    assert_text 'Всем привет! Как дела?'
  end
end
