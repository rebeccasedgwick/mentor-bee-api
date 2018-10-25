class LoginController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def authenticate
    user = User.find_by(email: auth_params[:email])
    if user && user.authenticate(auth_params[:password])
      json_response({
        auth_token: JsonWebToken.encode(user_id: user.id),
        user_id: user.id,
        name: user.name,
        email: user.email,
        pic: (request.base_url + "/avatars/#{user.pic}"),
        mentor_id: get_mentor(user)[:mentor_id],
        mentor_bio: get_mentor(user)[:mentor_bio],
        mentee_id: get_mentee(user)[:mentee_id],
        mentee_bio: get_mentee(user)[:mentee_bio]
        }, :created)
    else
      raise(ExceptionHandler::AuthenticationError, "Invalid credentials")
    end
  end

  private

    def auth_params
      params.permit(:email, :password)
    end

    def get_mentor(user)
      if Mentor.find_by(user_id: user.id)
        { mentor_id: user.mentor.id, mentor_bio: user.mentor.bio }
      else
        { mentor_id: nil, mentor_bio: nil }
      end
    end

    def get_mentee(user)
      if Mentee.find_by(user_id: user.id)
        { mentee_id: user.mentee.id, mentee_bio: user.mentee.bio }
      else
        { mentee_id: nil, mentee_bio: nil }
      end
    end
end
