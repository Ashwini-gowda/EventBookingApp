class NotifyEventUpdateJob < ApplicationJob
  queue_as :mailers

  def perform(event_id)
    event = Event.find(event_id)
    customers = event.bookings.includes(:customer).map(&:customer)

    customers.each do |customer|
      puts "Notifying #{customer.email} about updates to event '#{event.name}'."
      BookingMailer.event_updated_notification(customer, event).deliver_now
    end
  end
end
