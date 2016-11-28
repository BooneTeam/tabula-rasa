class SystemConfigsController < ApplicationController

  def create
    config = current_basic_user.system_configs.new(sys_config_params)
    if config.save
      render json: {config: config}
    end
  end

  def update
    action = params[:config_action]
    app = App.find(params[:app_id])
    config = SystemConfig.find(params[:id])
    config.call_action(action, app)
    if config.save
      html = (render_to_string partial: '/apps/app_menu_item', locals: {app: app}, layout: false)
      render json: {config: config, app: app, html: html}
    else
      render json: config.errors.messages
    end
  end

  def show
    config_id = params[:id]
    config = SystemConfig.find(config_id)
    json = []
    config.apps.each do |app|
      html = (render_to_string partial: '/apps/app_menu_item', locals: {app: app}, layout: false)
      json <<  {config: config, app: app, html: html}
    end
    render json: { apps: json, config: config }
  end

  def deploy
    if current_basic_user && current_basic_user.system_configs.find_by(id:params[:id])
      config = current_basic_user.system_configs.find(params[:id])
      app =  config.build_script_and_package
      send_file app
    else
      redirect_to new_basic_user_registration_path
    end
  end

  private

  def sys_config_params
    params.permit(:name)
  end


end