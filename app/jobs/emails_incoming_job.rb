require 'mail'

class EmailsIncomingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    companies_data = Company.select(:id, :email, :password).where(is_send: true).where.not(email: nil, password: nil)

    companies_data.each do |company_data|
      Mail.defaults do
        retriever_method :pop3, :address    => 'pop.gmail.com',
          :port       => 995,
          :user_name  => company_data[:email],
          :password   => ApplicationController.new.crypt.decrypt_and_verify(company_data[:password]),
          :enable_ssl => true
      end

      Mail.all.each do |mail|
        incoming = mail.first['from'].to_s == company_data[:email] ? false : true

        Email.create(
          from: mail.first['from'].to_s,
          body: mail.first.body.parts[0].decoded,
          subject: mail.first['subject'].to_s,
          to: mail.first['to'].to_s,
          date: mails.last['date'].to_s,
          company_id: company_data[:id],
          incoming: incoming
        )
      end
    end
  end
end
