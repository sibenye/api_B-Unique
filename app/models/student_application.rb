class StudentApplication < ActiveRecord::Base
  attr_accessible :admission_session, :first_name, :last_name, :email, :marital_status, :dob, :gender, :home_phone, :mobile_phone, :other_phone, :education, :address, :city, :state, :zipcode, :country
  attr_accessible :ssn, :dl_number, :dl_issue, :applying_for, :student_type, :period, :committment, :employer_name, :employer_number, :employer_address, :employer_city, :employer_state, :employer_zipcode, :employer_country
  attr_accessible :emergency_name, :emergency_home_number, :emergency_mobile_number, :emergency_relationship, :emergency_address, :emergency_city, :emergency_state, :emergency_zipcode, :emergency_country
  attr_accessible :physical_disability, :medication, :summary, :referrer, :submitted_on, :application_code, :accepted, :remarks, :paid, :paid_on, :amount, :signed

  def self.generateAppID(firstname, lastname, applyingfor)
  applyingfor = applyingfor.gsub(" ", ",")
  first = applyingfor[0,1]
  k = applyingfor.index(',')+1
  second = applyingfor[k,1]
  t = Time.now
  str = t.year.to_s+t.mon.to_s+t.day.to_s+t.hour.to_s+t.min.to_s+t.sec.to_s
  return 'S'+first+second+str+firstname[0,1]+lastname[0,1]
end

def self.getId(appcode)
  row = self.first(:conditions => "application_code = '#{appcode}'")
  id = row.id
  return id
end

def self.calculateSession
  a = Array.new
  b = Array.new
  c = Array.new
  d = Array.new
  
  dayOfYear = Time.now.yday
  thisYear = Time.now.year
  
  @sessions = Array.new
  if dayOfYear >= 351
    b.push((thisYear +1).to_s + " - April Admission" )
    b.push((thisYear +1).to_s + " - April Admission" )
    @sessions.push(b)
    
    c.push((thisYear +1).to_s + " - July Admission" )
    c.push((thisYear +1).to_s + " - July Admission" )
    @sessions.push(c)
    
    d.push((thisYear +1).to_s + " - October Admission" )
    d.push((thisYear +1).to_s + " - October Admission" )
    @sessions.push(d)
    
    a.push((thisYear +2).to_s + " - January Admission" )
    a.push((thisYear +2).to_s + " - January Admission" )
    @sessions.push(a)
  elsif dayOfYear >= 259
    a.push((thisYear +1).to_s + " - January Admission" )
    a.push((thisYear +1).to_s + " - January Admission" )
    @sessions.push(a)
    
    b.push((thisYear +1).to_s + " - April Admission" )
    b.push((thisYear +1).to_s + " - April Admission" )
    @sessions.push(b)
    
    c.push((thisYear +1).to_s + " - July Admission" )
    c.push((thisYear +1).to_s + " - July Admission" )
    @sessions.push(c)
    
    d.push((thisYear +1).to_s + " - October Admission" )
    d.push((thisYear +1).to_s + " - October Admission" )
    @sessions.push(d)
    
  elsif dayOfYear >= 167
    d.push((thisYear).to_s + " - October Admission" )
    d.push((thisYear).to_s + " - October Admission" )
    @sessions.push(d)
    
    a.push((thisYear +1).to_s + " - January Admission" )
    a.push((thisYear +1).to_s + " - January Admission" )
    @sessions.push(a)
    
    b.push((thisYear +1).to_s + " - April Admission" )
    b.push((thisYear +1).to_s + " - April Admission" )
    @sessions.push(b)
    
    c.push((thisYear +1).to_s + " - July Admission" )
    c.push((thisYear +1).to_s + " - July Admission" )
    @sessions.push(c)
    
  elsif dayOfYear >= 76
    c.push((thisYear).to_s + " - July Admission" )
    c.push((thisYear).to_s + " - July Admission" )
    @sessions.push(c)
    
    d.push((thisYear).to_s + " - October Admission" )
    d.push((thisYear).to_s + " - October Admission" )
    @sessions.push(d)
    
    a.push((thisYear +1).to_s + " - January Admission" )
    a.push((thisYear +1).to_s + " - January Admission" )
    @sessions.push(a)
    
    b.push((thisYear +1).to_s + " - April Admission" )
    b.push((thisYear +1).to_s + " - April Admission" )
    @sessions.push(b)
  end
  
  return @sessions
end

def self.getAppStatus(appCode, firstName, lastName)
  appCode_escaped = self.sanitize(appCode)
  firstName_escaped = self.sanitize(firstName)
  lastName_escaped = self.sanitize(lastName)
  row = self.first(:conditions => "application_code = #{appCode_escaped} AND first_name=#{firstName_escaped} AND last_name=#{lastName_escaped}")
  result = Hash.new
  if row != nil and row != ""
    result['session']=row.admission_session
    result['submitDate']=row.submitted_on.to_date
    result['appliedFor']=row.applying_for
    if row.accepted != nil and row.accepted != ""
      if row.accepted == "YES"
        result['message']='You have been accepted'
      elsif row.accepted == "NO"
        result['message']='Admission Denied'
      elsif row.accepted == "PENDING" and row.paid == "YES"
        result['message']='In Process'
      elsif row.accepted == "PENDING" and row.paid == "NO"
        result['message']='Application Fee has not been received'
      end
    else
      result['message']='In Process'
    end
  else
      result = nil
  end
  return result
end

def self.studentApplicationSearch(session, applicationId, email)
  result = []
  if session != nil
    admission_session = self.sanitize(session)
    result = self.find(:all,:conditions => "admission_session = #{admission_session}")
  elsif applicationId != nil
    appCode = self.sanitize(applicationId)
    result = self.find(:all,:conditions => "application_code = #{appCode}")
  elsif email != nil
    email = self.sanitize(email)
    result = self.find(:all,:conditions => "email = #{email}")
  end
  return result
end

def self.findDuplicate(params)
  firstName=params[:first_name]
  lastName=params[:last_name]
  email=params[:email]
  applyingFor=params[:applying_for]
  session=params[:admission_session]
  result = self.first(:conditions => "admission_session = '#{session}' AND applying_for='#{applyingFor}' AND email='#{email}' AND first_name='#{firstName}' AND last_name='#{lastName}'")
  if result != nil and result != ""
    return result
  end
  return nil
end

end
