# app/admin/offerings_admin.rb
Trestle.resource(:offerings) do
  menu do
    item :offerings, icon: "fa fa-briefcase"
  end

  table do
    column :id
    column :name
    column :status
    column :target_amount
    # actions do |toolbar, instance, admin|
    #   # if instance.can_advance_state?
    #   #   toolbar.link "Advance State", admin.path(:advance_state, id: instance.id), method: :post, class: "btn btn-success"
    #   # end
    # end
  end
  form do |offering|
    text_field :name
    select :status, Offering.statuses.keys.map { |status| [status.humanize, status] }
    number_field :target_amount
    number_field :min_invest_amount
    number_field :min_target
    number_field :max_target
    number_field :total_investors
    number_field :current_reserved_amount
    number_field :funded_amount
    number_field :reserved_investors

    tab :investments do
      table offering.investments, admin: :investments do
        column :id
        column :amount
        column :status
        column :investor, link: true
        column :investor_first_name, ->(investment) { investment.investor.user.first_name }
        column :investor_last_name, ->(investment) { investment.investor.user.last_name }
        column :created_at, align: :center
        # add button to change status
        # link_to "Send Email Update", admin.path(:email_update, id: instance.id), method: :post, class: "btn btn-info"
        actions do |toolbar, instance, admin|
          toolbar.link "Mark as Pending", admin.path(:mark_pending, id: instance.id), method: :post, class: "btn btn-warning"
        end
        actions
      end
    end
  end

  controller do
    def mark_pending
      investment = Investment.find(params[:id])
      
      if investment.update(status: 'pending')
        flash[:message] = "Investment marked as pending!"
      else
        flash[:error] = "Failed to mark investment as pending."
      end

      redirect_to admin.path(:show, id: investment.offering)
    end
  end

  routes do 
    post :mark_pending, on: :member
  end
end