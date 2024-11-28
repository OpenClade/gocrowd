Trestle.resource(:investors) do
  menu do
    item :investors, icon: "fa fa-user-tie"
  end

  table do
    column :id 
    column :kyc_status, ->(investor) {  investor.kyc_status.humanize }
    column :kyc_verified_at
    column :first_name, ->(investor) { investor.user.first_name }
    column :last_name, ->(investor) { investor.user.last_name }
    column :user, link: true
    # actions do |toolbar, instance, admin|
    #   if instance.kyc_status == 'pending'
    #     toolbar.link 'Approve KYC', admin.path(:approve_kyc, id: instance.id), method: :post, class: 'btn btn-success', icon: 'fa fa-check'
    #   end
    # end
  end

  form do |investor|
    select :user_id, User.all, label: "User"
    select :kyc_status, Investor.kyc_statuses.keys.map { |status| [status.humanize, status] }
    datetime_field :kyc_verified_at
  end

  controller do
    def approve_kyc
      investor = admin.find_instance(params)
      if investor.update(kyc_status: 'approved', kyc_verified_at: Time.current)
        flash[:message] = "KYC status updated to approved."
      else
        flash[:error] = "Failed to update KYC status."
      end
      redirect_to admin.path(:show, id: investor.id)
    end
  end

  routes do
    post :approve_kyc, on: :member
  end
end