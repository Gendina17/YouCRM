class TicketVersion < PaperTrail::Version
  self.table_name = :ticket_versions

  after_create -> { TicketLog.log_by_paper_trail!(self) }, if: -> { event == 'update' }
  after_create -> { TicketLog.log_initial!(self) }, if: -> { event == 'create' }
end
