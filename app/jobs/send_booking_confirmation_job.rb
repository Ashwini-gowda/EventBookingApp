class SendBookingConfirmationJob < ApplicationJob
  # queue_as :default

  queue_as :mailers

  def perform(booking_id)
    booking = Booking.find(booking_id)
    customer = booking.customer
    event = booking.event
    ticket = booking.ticket

    puts "Sending email confirmation to #{customer.email} for booking #{ticket.ticket_type} at #{event.name}."
    BookingMailer.event_updated_notification(customer, event).deliver_now
  end
end
