class AppsController < ApplicationController
  def index
    @all_configs  = !current_basic_user.nil? ? current_basic_user.system_configs : [SystemConfig.new]

    @current_config = @all_configs.first

    @apps = App.where.not(icon_path: nil).limit(50)
    # order by installs later
  end

  def new
    @category = Category.find(params[:category_id])
    @app = App.new
  end

  def create
    @app = App.new(app_params)
  end

  def search
    @current_config = SystemConfig.find_by(id:params[:config_id]) || nil
    @apps = App.where("name LIKE ?", "%#{params[:query]}%" ).limit(50)
    render "index", layout:false
  end

  private

  def app_params
    params[:app].merge({category_id: params[:category_id]}).permit(:body, :category_id)
  end
end