class Api::V1::SkillsController < Api::V1::ApiController       
    before_action :current_user
    before_action :user_type, only: [:create,:update,:destroy]

    respond_to :json

    def index 
        @skills = Skill.all 
        # render json: @skills, status: 200
    end 
        

    def show
        @skill = Skill.find(params[:id])
        # render json: {data: @skill, Current_User: current_user.name}, status: 200
    end 
    
    def create
        @skill= Skill.new(user_params)

        if @skill.save
            # render json: @skill ,status: 201
            # render 'create.json.jbuilder', status: 201  # For override status code
        else
            render json: {error: 'Unable to create Skill.' }, status: 400 
        end 
    end 
    
    def update
        @skill= Skill.find(params[:id]) 
        if @skill 
            @skill.update(user_params)
            # render json: { message: 'Skill successfully updated.' }, status: 200
         else 
            render json: { error: 'Unable to update Skill.'} , status:400 
        end 
    end 
    
    def destroy
        @skill = Skill.find(params[:id])

         if @skill
            @skill.destroy
            # render json: { message: 'Skill successfully deleted.' }, status: 200 
        else 
            render json: { error: 'Unable to delete Skill.' }, status: 400
        end 
    end 
    
    private
    def user_params 
        params.require(:skill).permit(:name) 
    end

    def user_type
        unless current_user.type == "Admin"
            render json: { message: 'You are Employee, So you dont have permission' },status: 403
        end
        return current_user
    end

    def current_user
      user =  User.find_by(custom_authentication_token: request.headers["Authorization"])

      unless user
        render json: :unauthorized,status: 403
      end
      return user
    end

end

