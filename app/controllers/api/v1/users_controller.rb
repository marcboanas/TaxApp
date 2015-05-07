module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_filter :restrict_access
      respond_to :json

      def show
        respond_with User.find(params[:id])
      end

      def create
        respond_with User.create(user_params)
      end

      def update
        respond_with User.update(params[:id],user_params)
      end

      def destroy
        respond_with User.destroy(params[:id])
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password)
      end

      def restrict_access
        authenticate_or_request_with_http_token do |token, options|
          ApiKey.exists?(access_token: token)
        end
      end
    end
  end
end
