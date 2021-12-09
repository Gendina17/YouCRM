class Admin::AnalyticsController < ApplicationController
  before_action :manager_analytics, :order_count, :general_statics, :ticket_categories_statistics, :ticket_status_statistics,
    :revenue_by_month, :revenues_in_category, only: :index

  def index

  end

  def manager_analytics
    sum = Hash.new(0)
    array = Ticket.company(company.id)
                  .map{|w| [w.manager&.full_name, w.product&.price] if w.manager.present? && w.product.present?}.compact

    @manager_analytics = [['Менеджер', 'Общая выручка']] + array.each_with_object(sum) {|a, sum| sum[a[0]] +=a[1] }.to_a
  end
  #выудить компанию
  def order_count
    if current_user.company.type_product == Company::TYPE_PRODUCT.first.first.to_s
      @order_count = Product.select(:name, :created_at).group(:name).count(:created_at).
        map {|hash| [hash[0], hash[1], get_colors[rand(get_colors.size)]] }
    else
      @order_count = Service.select(:name, :created_at).group(:name).count(:created_at).
        map {|hash| [hash[0], hash[1], get_colors[rand(get_colors.size)]] }
    end
  end

  def general_statics
    if current_user.company.type_client == Company::TYPE_CLIENTS.first.first.to_s
      new_client_count = Client.company(company.id).where('created_at > ?', Date.today.at_beginning_of_month).count
    else
      new_client_count = ClientCompany.company(company.id).where('created_at > ?', Date.today.at_beginning_of_month).count
    end

    open_ticket_count = Ticket.company(company.id).open.where('created_at > ?', Date.today.at_beginning_of_month).count
    close_ticket_count = Ticket.company(company.id).where(is_closed: true).where('created_at > ?', Date.today.at_beginning_of_month).count

    if current_user.company.type_product == Company::TYPE_PRODUCT.first.first.to_s
      new_product_count = Product.where('created_at > ?', Date.today.at_beginning_of_month).count
      important_count = Product.where('created_at > ?', Date.today.at_beginning_of_month).where(is_important: true).count
    else
      new_product_count = Service.where('created_at > ?', Date.today.at_beginning_of_month).count
      important_count = Service.where('created_at > ?', Date.today.at_beginning_of_month).where(is_important: true).count
    end

    tickets = Ticket.company(company.id).select('created_at, updated_at').where(is_closed: true)
                    .map{|w| (w.updated_at - w.created_at)/3600/24}

    avg_close_time = tickets.sum / tickets.size unless tickets.size.zero?

    orders_for_client_count = Ticket.company(company.id).where.not(product_id: nil)
          .pluck(:client_id).each_with_object(Hash.new(0)){ |num, hash| hash[num] += 1 }.values

    avg_orders_for_client_count = orders_for_client_count.sum / orders_for_client_count.size unless orders_for_client_count.size.zero?

    total_revenues = Ticket.company(company.id).map{|w| w.product&.price if w.product.present?}.compact.sum

                           @general_statics = [['Новые клиенты', new_client_count], ['Открытые тикеты', open_ticket_count],
      ['Закрытые тикеты', close_ticket_count], ['Количество созданных заказов', new_product_count],
      ['Важные заказы', important_count], ['Продолжительность жизни тикета до закрытия (дн)', avg_close_time],
      ['Среднее количество заказов у клиента', avg_orders_for_client_count], ['Общая выручка (руб)', total_revenues]]
  end

  def ticket_status_statistics
    @ticket_status_statistics = Ticket.company(company.id).pluck(:status_id)
                                      .compact.each_with_object(Hash.new(0)){ |num, hash| hash[num] += 1 }
                                  .map{|key, value|[Status.find(key).title, value, get_colors[rand(get_colors.size)]]}
  end

  def ticket_categories_statistics
    @ticket_categories_statistics = Ticket.company(company.id).pluck(:category_id).compact
                                          .each_with_object(Hash.new(0)){ |num, hash| hash[num] += 1 }
                                      .map{|key, value|[Category.find(key).title, value, get_colors[rand(get_colors.size)]]}
  end

  def revenues_in_category
    if current_user.company.type_product == Company::TYPE_PRODUCT.first.first.to_s
      category_with_price =  Ticket.company(company.id).pluck(:category_id, :product_id)
                                     .map{|w| [Category.find(w[0]).title, Product.find(w[1]).price] if w[0].present? && w[1].present?}.compact
    else
      category_with_price =  Ticket.company(company.id).pluck(:category_id, :product_id)
                                     .map{|w| [Category.find(w[0]).title, Service.find(w[1]).price] if w[0].present? && w[1].present?}.compact
    end
    @revenues_in_category = [%w[Категория Выручка]] + category_with_price.each_with_object(Hash.new(0)){ |num, hash| hash[num[0]] += num[1] }.to_a
  end

  def revenue_by_month

  end

  private

  def company
    @company = current_user.company
  end

  def get_colors
    %w[#b87333 silver gold grey red blue green pink violet brown]
  end
end

# просмотреть все запросы чтоб компания и время и все нормуч
# выручка по месяцам
# в этом месяце кто активней всего в месяце(на основе писем и тп)
# видеть не видеть схему и картинка закрузки
# в куках

