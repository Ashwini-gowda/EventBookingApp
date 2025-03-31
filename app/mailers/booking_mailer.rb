class BookingMailer < ApplicationMailer
    default from: 'no-reply@example.com'  # Change this to your sender email
  
    def booking_confirmation(booking)
        @booking = booking
        mail(to: @booking.customer.email, subject: 'Your Booking Confirmation')
    end
  
    def event_updated_notification(customer, event)
        @customer = customer
        @event = event
        mail(to: @customer.email, subject: "Update on #{event.name}")
    end
  end