JWTSessions.algorithm = "HS256"
JWTSessions.encryption_key = Rails.application.credentials[Rails.env.to_sym][:secret_jwt_encryption_key]
