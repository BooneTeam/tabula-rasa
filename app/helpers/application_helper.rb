module ApplicationHelper

  def resource_name
    :basic_user
  end

  def resource
    @resource ||= BasicUser.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:basic_user]
  end

end
