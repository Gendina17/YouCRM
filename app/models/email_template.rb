class EmailTemplate < ApplicationRecord
  belongs_to :company
  scope :company,    ->(id) { where(company_id: id) }

  def parse_body(client_id, manager_id, product_id)
    self.body
        .gsub('{{ client.full_name }}', self.company.clients.find_by(id: client_id).full_name)
        .gsub('{{ manager.full_name }}', User.find_by(id: manager_id).full_name)
        .gsub('{{ manager.email }}', User.find_by(id: manager_id).email)
        .gsub('{{ product.name }}', self.company.type_product == 'product' ? Product.find_by(id: product_id).name : Service.find_by(id: product_id).name )
  end
end
