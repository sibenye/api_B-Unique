class EmployeeApplication < ActiveRecord::Base
  attr_accessible :experience, :first_name, :last_name, :email, :marital_status, :dob, :gender, :home_phone, :mobile_phone, :other_phone, :education, :address, :city, :state, :zipcode, :country
  attr_accessible :ssn, :dl_number, :dl_issue, :applying_for, :employment_type, :period, :employer_name, :employer_number, :employer_address, :employer_city, :employer_state, :employer_zipcode, :employer_country
  attr_accessible :emergency_name, :emergency_home_number, :emergency_mobile_number, :emergency_relationship, :emergency_address, :emergency_city, :emergency_state, :emergency_zipcode, :emergency_country
  attr_accessible :physical_disability, :medication, :summary, :referrer, :submitted_on, :application_code, :accepted, :remarks, :signed

  def self.generateAppID(firstname, lastname, applyingfor)
    applyingfor = applyingfor.gsub(" ", ",")
    first = applyingfor[0,1]
    #k = applyingfor.index(',')+1
    #second = applyingfor[k,1]
    t = Time.now
    str = t.year.to_s+t.mon.to_s+t.day.to_s+t.hour.to_s+t.min.to_s+t.sec.to_s
    return 'E'+first+str+firstname[0,1]+lastname[0,1]
  end

  def self.getId(appcode)
    row = self.first(:conditions => "application_code = '#{appcode}'")
    id = row.id
    return id
  end
  
  def self.getAppStatus(appCode, firstName, lastName)
    appCode_escaped = self.sanitize(appCode)
    firstName_escaped = self.sanitize(firstName)
    lastName_escaped = self.sanitize(lastName)
    row = self.first(:conditions => "application_code = #{appCode_escaped} AND first_name=#{firstName_escaped} AND last_name=#{lastName_escaped}")
    result = Hash.new
    if row != nil and row != ""
      result['submitDate']=row.submitted_on.to_date
      result['appliedFor']=row.applying_for
      if row.accepted != nil and row.accepted != ""
        if row.accepted == "YES"
          result['message']='You have been offered this position'
        elsif row.accepted == "NO"
          result['message']='You were not accepted for this position'
        elsif row.accepted == "PENDING"
          result['message']='In Process'
        end
      else
        result['message']='In Process'
      end
    else
        result = nil
    end
    return result
  end
  
  def self.employeeApplicationSearch(appliedFor, applicationId)
    if appliedFor != nil
      applied_for = self.sanitize(appliedFor)
      result = self.find(:all,:conditions => "applied_for = #{applied_for}")
      return result
    elsif applicationId != nil
      appCode = self.sanitize(applicationId)
      result = self.find(:all,:conditions => "application_code = #{appCode}")
      return result
    end
 end
end
