require 'application_system_test_case'

class RegistrationTest < ApplicationSystemTestCase
  setup do
    @company = Company.create!(name: 'First')
    role = Role.create!(name: 'Admin', company: @company)
    @user = User.create!(name: 'Нина', surname: 'Гендина', company_id: @company.id,
        email: 'gnb@mail.ru', password: '123456', role_id: role.id )
  end

  test 'authorization_with_incorrect_data' do
    visit root_url
    click_on 'Авторизоваться'
    fill_in 'company', with: 'SuperName'
    fill_in 'email', with: 'test@mail.ru'
    fill_in 'password', with: '123456'
    click_on 'Войти'
    assert_text 'CRM для компании с данным именем не существует'
  end

  test 'authorization_with_correct_data' do
    visit root_url
    click_on 'Авторизоваться'
    fill_in 'company', with: @company.name
    fill_in 'email', with: @user.email
    fill_in 'password', with: @user.password
    click_on 'Войти'
    assert_text 'Вы не закончили регистрацию, подтвердите свой профиль'
  end

  test 'test_create_crm' do
    visit root_url
    click_on 'Создать CRM'
    fill_in 'company', with: 'Second'
    fill_in 'email', with: 'gnb@mail.ru'
    fill_in 'password', with: '123456'
    fill_in 'password_confirmation', with: '123456'
    fill_in 'name', with: 'Нина'
    fill_in 'surname', with: 'Гендина'
    click_on 'Создать'
    assert_text 'Письмо для завершения регестрации отправлено Вам на почту'
  end

   test 'test_password_recovery' do
      visit root_url
      click_on 'Авторизоваться'
      click_link(href: '##')
      fill_in 'company', with: 'First'
      fill_in 'email', with: 'gnb@mail.ru'
      click_on 'Востановить пароль'
      assert_text 'Письмо для восстановления пароля отправлено Вам на почту'
    end
end
