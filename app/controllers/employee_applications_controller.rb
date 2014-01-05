class EmployeeApplicationsController < ApplicationController
  
  def retrieve
    if (params[:mode] == 'status') then
      required_fields = ['app_code', 'first_name', 'last_name']
      if !contactFormvalidity(required_fields, nil)
        @status = 'Invalid Parameter'
        @result = nil
      else
        @result = EmployeeApplication.getAppStatus(params[:app_code], params[:first_name], params[:last_name])
      end
    elsif (params[:mode] == 'byId') then
      required_fields = ['app_code']
      if !contactFormvalidity(required_fields, nil)
        @status = 'Invalid Parameter'
        @result = nil
      else
        applicationId = params[:app_code]
        @result = EmployeeApplication.employeeApplicationSearch(nil, applicationId)
      end
    elsif (params[:mode] == 'all') then
      @result = EmployeeApplication.all
    else
      @result = nil
      @status = 'Invalid Parameter'
    end
    
    respond_to do |format|
      if (@result != [] and @result != nil) then
        format.json { render :json => {:status => 0, :message => 'success', :response =>@result} }
      elsif (@status == 'Invalid Parameter')
        format.json { render :json => {:status => 110, :message=>'Required Parameter Not Provided'}}
      else
        format.json { render :json => {:status => 220, :message=>'Not Found'}}
      end
    end
  end
  
  def create
    #debugger
    @stparams = params[:employee_application]
    @employee_application = EmployeeApplication.new(params[:employee_application]) 
    #debugger   
    required_fields = ['experience', 'first_name', 'last_name', 'email', 'marital_status', 'dob', 'gender', 'mobile_phone', 'education', 'address', 'city', 'state', 'zipcode', 'country', 'ssn', 'applying_for', 'employment_type', 'period', 'emergency_name', 'emergency_mobile_number', 'emergency_relationship', 'emergency_address', 'emergency_city', 'emergency_state', 'emergency_zipcode', 'emergency_country']
    #debugger
    if !contactFormvalidity(required_fields, @employee_application) 
      respond_to do |format|       
        format.json { render :json => {:errors=>{:status => 110, :message => "Required parameter not provided"}}, :status => :unprocessable_entity }
      end        
    else
      #debugger
      @employee_application.application_code = EmployeeApplication.generateAppID(@stparams[:first_name], @stparams[:last_name], @stparams[:applying_for])
      @employee_application.submitted_on = Date.today
      
      respond_to do |format|
        if @employee_application.save
          sendEmail('employee', @employee_application)
          format.json { render :json => {:status => 0, :message => 'success', :response =>@employee_application}, :status => :created}
        else
          format.json { render :json => {:errors => @employee_application.errors}, :status => :unprocessable_entity }
        end
      end
    end
  end
  
  def update
    @employee_application = EmployeeApplication.find(params[:id])
    @stparams = params[:employee_application]
    required_fields = ['experience', 'first_name', 'last_name', 'email', 'marital_status', 'dob', 'gender', 'mobile_phone', 'education', 'address', 'city', 'state', 'zipcode', 'country', 'ssn', 'applying_for', 'employment_type', 'period', 'emergency_name', 'emergency_mobile_number', 'emergency_relationship', 'emergency_address', 'emergency_city', 'emergency_state', 'emergency_zipcode', 'emergency_country']
    if !contactFormvalidity(required_fields, @stparams) 
      respond_to do |format|       
        format.json { render :json => {:errors=>{:status => 110, :message => "Required parameter not provided"}}, :status => :unprocessable_entity }
      end        
    else
      respond_to do |format|
        if @employee_application.update_attributes(@stparams)
          format.json { render :json => @employee_application, :status => :ok}
        else
          format.json { render :json => @employee_application.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
end
