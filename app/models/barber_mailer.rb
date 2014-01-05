class BarberMailer < ActionMailer::Base
  
  def contact_email(message)
    content_type 'text/html'
    recipients  "buba_admin@bubaonline.com"
    from        message["email"]
    subject     "Message From BUBA_SITE"
    body        :message => message
    #send_on     Time.now
  end
  
  def complaint_email(message)
    content_type 'text/html'
    recipients  "buba_admin@bubaonline.com"
    from        message["email"]
    subject     "Customer Complaint From BUBA_SITE"
    body        :message => message
    #send_on     Time.now
  end
  
  def confirmation_email_for_student(application, sub, fro)
    content_type 'text/html'
    recipients  application.email
    from        fro
    subject     sub
    body        :message => application
  end
  
  def student_acceptance_email(application, sub, fro)
    content_type 'text/html'
    recipients  application.email
    from        fro
    subject     sub
    body        :message => {"appId" => application.application_code}
  end
  
  def student_denial_email(application, sub, fro, status)
    content_type 'text/html'
    recipients  application.email
    from        fro
    subject     sub
    body        :message => {"reason" => application.remarks, "status" => status}
  end
  
  def confirmation_email_for_employee(application, sub, fro)
    content_type 'text/html'
    recipients  application.email
    from        fro
    subject     sub
    body        :message => application
  end
  
  def admin_notification_email(application, sub, to)
    content_type 'text/html'
    recipients  to
    from        application.email
    subject     sub
    body        :message => application
  end
  
  def customer_notification(message, to, sub)
    content_type 'text/html'
    recipients  to
    from        "b-uniqueacademy@bubba-online.com"
    subject     sub
    body        :message => message
  end

end
