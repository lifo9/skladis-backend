module AuthHelper
  def sign_in_as(user)
    payload = { user_id: user.id }
    session = JWTSessions::Session.new(payload: payload, namespace: "user_#{user.id}")
    tokens = session.login
    request.cookies[JWTSessions.access_cookie] = tokens[:access]
    request.headers[JWTSessions.csrf_header] = tokens[:csrf]
  end

  shared_examples_for 'rejects access to unauthorized users' do |method, action, params = {}, return_codes = [403]|
    it 'should not be accessible' do
      send(method.to_sym, action, params: params)

      expect(response.status).to satisfy { |code| return_codes.include?(code) }
    end
  end
end