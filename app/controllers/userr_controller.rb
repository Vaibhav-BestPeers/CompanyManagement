class UserrController < ApplicationController

   layout 'login'

    before_action :set_user, only: [:index, :new, :create]  

    def index
      if @user.profile == nil
        redirect_to controller: 'userr', action: 'new'
      end
    end

        def show
          @user = User.find(params[:id])    
        end
          
        def new
          @profile = @user.build_profile
        end
          
        def create
       
         
          @profile = @user.build_profile(create_profile_params)
          @picture = @user.build_picture(params[:profile][:picture].permit(:name,:image))
      
          if @profile.save && @picture.save
             redirect_to userr_index_path, success: 'Profile successfully created.'
          else
              render('new')
          end
          
        end
        
        def add_employee_skills
          @user = User.find(params[:id])
          data = add_employee_skills_params
          data.each do |data|
            @user.employee_skills.create(skill_id: data)
          end
          redirect_to edit_userr_path(@user.id)
        end
  
          
        def edit
          @user = User.find(params[:id])
        end
       def update

          @user = User.find(params[:id])
          if @user.update(update_profile_params)

            redirect_to userr_index_path(@user)
          else
              render('edit')
          end
        end
          
        def delete

          @user = User.find(params[:id])
          @profile = @user.profile
        end

        def destroy
          @user = User.find(params[:id])
          @profile = @user.profile
          @profile.destroy
          redirect_to  userr_index_path
        end
        
        def delete_employee_skills
          @user = User.find(params[:id])
          @user.employee_skills.find(params[:skill_id]).destroy
          redirect_to edit_userr_path(@user.id), success: 'Deleted Successfully'
        end
  
  private
  def create_profile_params
    params.require(:profile).permit(:first_name,:last_name,:dob,:mob_no,:address)
  end
  
    def update_profile_params

      if @user.type == "Admin"
        #return params.require(:admin).permit(:name,:email, profile_attributes: [:first_name, :last_name, :dob, :mob_no, :address])
        return params.require(:admin).permit(:name,:email, profile_attributes: [:first_name, :last_name, :dob, :mob_no, :address],picture_attributes:[:name,:image] )

      elsif @user.type == "Employee"
        return params.require(:employee).permit(:name,:email, profile_attributes: [:first_name, :last_name, :dob, :mob_no, :address],picture_attributes:[:name,:image] )
      end
    end

    def add_employee_skills_params
      obj = params[:employee_skill][:skill_id]
      obj.reject!(&:blank?)
      return obj
    end

    def set_user
        @user = current_user
    end
end
