require 'application_system_test_case'

class SettingsTest < ApplicationSystemTestCase
  setup do
    @company = Company.create!(name: 'First')
    role = Role.create!(name: 'Admin', company: @company, the_role: Role::ACTIONS.keys.to_json)
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

  test 'test_create_role' do
    visit settings_url
    click_on 'Создать должность и права'
    fill_in 'name', with: 'role'
    find(:css, ".tttt[value='add_users']").set(true)
    click_on 'Создать'
    assert_text 'Роль успешно создана'
  end

  test 'test_role_assignment' do
      visit settings_url
      click_on 'Создать должность и права'
      click_on 'Присвоить'
      assert_text 'Пользователю успешно присвоена роль'
    end

    test 'edit_profile' do
        visit settings_url
        click_on 'Профиль'
        fill_in 'name', with: 'Олег'
        click_on 'Сохранить'
        assert_text 'Данные успешно изменены'
      end

      test 'create_task' do
          visit settings_url
          click_on 'Задачи'
          fill_in 'subject', with: 'Крутая задача'
          fill_in 'body', with: 'Тело крутой задачи'
          fill_in 'until_date', with: '2021-12-12'
          click_on 'Создать'
          assert_text 'Тело крутой задачи'
        end
end
