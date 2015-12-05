class Admin::OwnersController < Admin::BaseController
  def index
    @owners = User.joins(:roles).where("title= ?", "owner")
  end

 def update
   user = User.find(params[:id])
   user.update_attributes!(owner_status: params[:owner_status])
   user.roles.update_attributes!(title: update_role(user))
   redirect_to admin_owners_path
 end
end
