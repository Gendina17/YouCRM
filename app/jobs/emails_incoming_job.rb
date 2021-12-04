require 'mail'

class EmailsIncomingJob < ApplicationJob
  queue_as :default

  def perform(*args)
    companies_data = Company.select(:id, :email, :password, :type_client, :default_email_id).where(is_send: true).where.not(email: nil, password: nil)

    companies_data.each do |company_data|
      Mail.defaults do
        retriever_method :pop3, :address    => 'pop.gmail.com',
          :port       => 995,
          :user_name  => company_data[:email],
          :password   => ApplicationController.new.crypt.decrypt_and_verify(company_data[:password]),
          :enable_ssl => true
      end

      begin
        Mail.all.each do |mail|
          from = mail['from'].to_s.split('<').last[0..-2]
          to = mail['to'].to_s.split('<').last[0..-2]
          incoming = from == company_data[:email] ? false : true
          next unless incoming

          email = Email.create!(
            from: from,
            body: (mail.body.parts[0].present? ? mail.body.parts[0]&.decoded[0..-2] : mail.body.to_s[0..-2] ),
            subject: mail['subject'].to_s,
            to: to,
            date: mail['date'].to_s,
            company_id: company_data[:id],
            incoming: incoming,
            client_id: (company_data[:type_client] == 'client' ? Client.find_or_create_by!(email: from,
              company_id: company_data[:id]).id : ClientCompany.find_or_create_by!(email: from, company_id: company_data[:id]).id),
            client_type: (company_data[:type_client] == 'client' ? 'Client' : 'ClientCompany')
          )

          unless email&.client&.tickets&.where(is_closed: false).present?
            Ticket.create!(
              subject: "Новое письмо с почты #{from}",
              company_id: company_data[:id],
              client: email.client
            )

            unless company_data[:default_email_id].nil?
              template = EmailTemplate.find_by(id: company_data[:default_email_id])

            options = {
              address: "smtp.gmail.com",
              port: 587,
              domain: 'localhost',
              user_name: company_data[:email],
              password: ApplicationController.new.crypt.decrypt_and_verify(company_data[:password]),
              authentication: 'plain',
              enable_starttls_auto: true
            }

            Mail.defaults do
              delivery_method :smtp, options
            end

            Mail.deliver do
              to from
              from company_data[:email]
              subject template.subject
              html_part do
                content_type 'text/html; charset=UTF-8'
                body template.body
              end
            end
              Email.create(to: from, from: company_data[:email], subject: template.subject, body: template.body,
                company_id: company_data[:id], date: Time.current, incoming: false, client: email.client)
            end
          end
        end
      rescue Net::POPAuthenticationError
      end
    end
  end
end
