# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  def contactFormvalidity(required_fields, obj)
    
    required_fields.each do |r|
      if obj == nil
        if params[r] == "" or params[r] == nil
          return false
        end
      else
        if obj[r] == "" or obj[r] == nil
        return false
      end
      end
    end
    return true
  end
  
  def sendEmail(type, obj)
    if (type == 'student')
      from = "bubba_admissions@bubba-online.com"
      subject_a = "Thank you. Application Received"
      BarberMailer.deliver_confirmation_email_for_student(obj, subject_a, from)
          
      subject = "New Student Application"
      to = "bubba_admissions@bubba-online.com"
      BarberMailer.deliver_admin_notification_email(obj, subject, to)
    elsif (type == 'student_status')
      from = "bubba_admissions@bubba-online.com"
      subject = "BUBBA Application Status"
      if (obj.accepted == 'YES')
      BarberMailer.deliver_student_acceptance_email(obj, subject, from)
      elsif (obj.accepted == 'NO' or obj.accepted == 'PENDING')
        status = obj.accepted
        if (obj.accepted == 'NO') then
          status = 'Denied'
        end
        BarberMailer.deliver_student_denial_email(obj, subject, from, status)
      end
    elsif (type == 'employee')
      from = "bubba_employment@bubba-online.com"
      subject_a = "Thank you. Application Received"
      BarberMailer.deliver_confirmation_email_for_employee(obj, subject_a, from)
        
      subject_b = "New Employee Application"
      to = "bubba_employment@bubba-online.com"
      BarberMailer.deliver_admin_notification_email(obj, subject_b, to)
    end
  end
end
