class StudentApplicationsController < ApplicationController
  
  def retrieve
    if (params[:mode] == 'status') then
      required_fields = ['app_code', 'first_name', 'last_name']
      if !contactFormvalidity(required_fields, nil)
        @status = 'Invalid Parameter'
        @result = nil
      else
        @result = StudentApplication.getAppStatus(params[:app_code], params[:first_name], params[:last_name])
      end
    elsif (params[:mode] == 'byId') then
      required_fields = ['app_code']
      if !contactFormvalidity(required_fields, nil)
        @status = 'Invalid Parameter'
        @result = nil
      else
        applicationId = params[:app_code]
        @result = StudentApplication.studentApplicationSearch(nil, applicationId, nil)
      end
    elsif (params[:mode] == 'byEmail') then
      required_fields = ['email']
      if !contactFormvalidity(required_fields, nil)
        @status = 'Invalid Parameter'
        @result = nil
      else
        email = params[:email]
        @result = StudentApplication.studentApplicationSearch(nil, nil, email)
      end
    elsif (params[:mode] == 'bySession') then
      required_fields = ['month','year']
      if !contactFormvalidity(required_fields, nil)
        @status = 'Invalid Parameter'
        @result = nil
      else
        admission_session = params[:year]+' - '+params[:month]+' Admission'
        @result = StudentApplication.studentApplicationSearch(admission_session, nil, nil)
      end    
    elsif (params[:mode] == 'all') then
      @result = StudentApplication.all
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
    @stparams = params[:student_application]
    @student_application = StudentApplication.new(params[:student_application]) 
    #debugger   
    required_fields = ['admission_session', 'first_name', 'last_name', 'email', 'marital_status', 'dob', 'gender', 'mobile_phone', 'education', 'address', 'city', 'state', 'zipcode', 'country', 'ssn', 'applying_for', 'student_type', 'period', 'emergency_name', 'emergency_mobile_number', 'emergency_relationship', 'emergency_address', 'emergency_city', 'emergency_state', 'emergency_zipcode', 'emergency_country']
    #debugger
    if !contactFormvalidity(required_fields, @student_application) 
      respond_to do |format|       
        format.json { render :json => {:errors=>{:status => 110, :message => "Required parameter not provided"}}, :status => :unprocessable_entity }
      end        
    else
      #check if this application has already been saved
      @duplicate_student_application = StudentApplication.findDuplicate(@stparams)
      if @duplicate_student_application != nil
        sendEmail('student', @duplicate_student_application)
        respond_to do |format|
          format.json { render :json => {:status => 0, :message => 'success', :response =>@duplicate_student_application}, :status => :created}
        end
      else
        @student_application.application_code = StudentApplication.generateAppID(@stparams[:first_name], @stparams[:last_name], @stparams[:applying_for])
        @student_application.submitted_on = Date.today
        
        respond_to do |format|
          if @student_application.save
            sendEmail('student', @student_application)
            format.json { render :json => {:status => 0, :message => 'success', :response =>@student_application}, :status => :created}
          else
            format.json { render :json => {:errors => @student_application.errors}, :status => :unprocessable_entity }
          end
        end
      end
    end
  end
  
  def update
    
    @stparams = params[:student_application]
    required_fields = ['id']
    if !contactFormvalidity(required_fields, @stparams) 
      respond_to do |format|       
        format.json { render :json => {:errors=>{:status => 110, :message => "Required parameter not provided"}}, :status => :unprocessable_entity }
      end        
    else
      @student_application = StudentApplication.find(params[:id])
      
      respond_to do |format|
        if @student_application.update_attributes(@stparams)
          #@student_application = StudentApplication.find(params[:id])
          if (params[:status_change] == "true") then
            sendEmail('student_status', @student_application)
          end
          format.json { render :json => @student_application, :status => :ok}
        else
          format.json { render :json => @student_application.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
end
