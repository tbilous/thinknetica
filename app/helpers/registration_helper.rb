module RegistrationHelper
  def omniauth_present?(resource, val)
    resource.omniauth_providers.select { |c| c.to_s == val }.present?
  end
end
