module Api
  module V1
    class ApiController < ApplicationController
      http_basic_authenticate_with name: ENV["API_AUTH_NAME"], password: ENV["API_AUTH_PASSWORD"], :only => [:signup, :signin, :get_token]
      before_filter :check_for_valid_authtoken, :except => [:signup, :signin, :get_token]

      def signup
        if request.post?
          if params[:email] && params[:password]
            params[:user] = Hash.new
            params[:user][:email] = params[:email]
            begin
              decrypted_pass = AESCrypt.decrypt(params[:password], ENV["API_AUTH_PASSWORD"])
            rescue Exception => e
              decrypted_pass = nil
            end
            params[:user][:password] = decrypted_pass
            params[:user][:verification_code] = rand_string(20)
            user = User.new(user_params)
            if user.save
              render :json => user.to_json, :status => 200
            else
              error_str = ""
              user.errors.each{ |attr, msg|
                error_str += "#{attr} - #{msg},"
              }
              e = Error.new(:status => 400, :message => error_str)
              render :json => e.to_json, :status => 400
            end
          end
        end
      end

      def signin
        if request.post?
          if params && params[:email] && params[:password]
            user = User.where(:email => params[:email]).first

            if user
              if User.authenticate(true, params[:email], params[:password])
                if !user.api_authtoken || (user.api_authtoken && user.authtoken_expiry < Time.now)
                  auth_token = rand_string(20)
                  auth_expiry = Time.now + (24*60*60)
                  user.update_attributes(:api_authtoken => auth_token, :authtoken_expiry => auth_expiry)
                end

                render :json => user.to_json, :status => 200
              else
                e = Error.new(:status => 401, :message => "Wrong Password")
                render :json => e.to_json, :status => 401
              end
            else
              e = Error.new(:status => 400, :message => "no User found by this email ID")
              render :json => e.to_json, :status => 400
            end
          else
            e = Error.new(:status => 400, :message => "required parameters are missing")
            render :json => e.to_json, :status => 400
          end
        end
      end

      def reset_password
        if request.post?
          if params && params[:old_password] && params[:new_password]
            if @user
              if @user.authtoken_expiry > Time.now
                authenticate_user = User.authenticate(true, @user.email, params[:old_password])
                if authenticate_user && !authenticate_user.nil?
                  auth_token = rand_string(20)
                  auth_expiry = Time.now + (24 * 60 * 60)
                  begin
                    new_password = AESCrypt.decrypt(params[:new_password], ENV["API_AUTH_PASSWORD"])
                  rescue Exception => e
                    new_password = nil
                    puts "error - #{e.message}"
                  end
                  new_password_salt = BCrypt::Engine.generate_salt
                  new_password_digest = BCrypt::Engine.hash_secret(new_password, new_password_salt)
                  @user.update_attributes(:password => new_password, :api_authtoken => auth_token, :authtoken_expiry => auth_expiry, :password_salt => new_password_salt, :password_hash => new_password_digest)
                  render :json => @user.to_json, :status => 200
                else
                  e = Error.new(:status => 401, :message => "Wrong Password")
                  render :json => e.to_json, :status => 401
                end
              else
                e = Error.new(:status => 401, :message => "Authtoken is invalid or has expired. Kindly refresh the token and try again!")
                render :json => e.to_json, :status => 401
              end
            else
              e = Error.new(:status => 400, :message => "No user record found for this email ID")
              render :json => e.to_json, :status => 400
            end
          else
            e = Error.new(:status => 400, :message => "required parameters are missing")
            render :json => e.to_json, :status => 400
          end
        end
      end

      def get_token
        if params && params[:email]
          user = User.where(:email => params[:email]).first
          if user
            if !user.api_authtoken || (user.api_authtoken && user.authtoken_exipry < Time.now)
              auth_token = rand_string(20)
              auth_expiry = Time.now + (24 * 60 * 60)
              user.update_attributes(:api_authtoken => auth_token, :authtoken_expiry => auth_expiry)
            end
            render :json => user.to_json(:only => [api_authtoken, :authtoken_expiry])
          else
            e = Error.new(:status => 400, :message => "No user record found for this email ID")
            render :json => e.to_json, :status => 400
          end
        else
          e = Error.new(:status => 400, :message => "required parameters are missing")
          render :json => e.to_json, :status => 400
        end
      end

      def clear_token
        if @user.api_authtoken &&@user.authtoken_expiry > Time.now
          @user.update_attributes(:api_authtoken => nil, :authtoken_expiry => nil)
          m = Message.new(:status => 200, :message => "Token cleared")
          render :json => m.to_json, :status => 200
        else
          e = Error.new(:status => 401, :message => "you don't have permission to do this task")
          render :json => e.to_json, :status => 401
        end
      end

      private

      def check_for_valid_authtoken
        authenticate_or_request_with_http_token do |token, options|
          @user = User.where(:api_authtoken => token).first
        end
      end

      def rand_string(len)
        o = [('a'..'z'),('A'..'Z')].map{ |i| i.to_a }.flattern
        string = (0..len).map{ o[rand(o.length)] }.join
        return string
      end

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
      end
    end
  end
end
