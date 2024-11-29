# app/admin/investments_admin.rb
Trestle.resource(:investments) do
  menu do
    item :investments, icon: "fa fa-money-check-alt"
  end

  table do
    column :id
    column :amount
    column :status do |investment|
      status_tag(investment.status, class: investment.status == 'received' ? :success : :warning )
    end
    column :investor, link: true
    column :investor_first_name, ->(investment) { investment.investor.user.first_name }
    column :investor_last_name, ->(investment) { investment.investor.user.last_name }
    column :offering, link: true
    column :created_at, align: :center
    actions do |toolbar, instance, admin|
      if instance.status == 'pending'
        toolbar.link "Mark as Received", admin.path(:mark_received, id: instance.id), method: :put, class: "btn btn-success"
      end
    end

    column :bank_statement do |investment|
      if investment.bank_statement.attached? 
        link_to "Approve", admin.path(:approve, id: instance.id), method: :put, class: "btn btn-success"
      else
        "No file attached"
      end
    end
  end

  form do |investment|
    select :investor_id, Investor.all, label: "Investor"
    select :offering_id, Offering.all, label: "Offering"
    number_field :amount
    select :status, Investment.statuses.keys.map { |status| [status.humanize, status] }
  end

  controller do
    def mark_received
      puts params
      investment = Investment.find(params[:id])
      
      if investment.update(status: 'received')
        flash[:message] = "Investment marked as received!"
      else
        flash[:error] = "Failed to mark investment as received."
      end
      # return to offerings
      redirect_to admin.path(:show, id: investment.offering)
    end

    def mark_pending
      investment = Investment.find(params[:id])
      
      if investment.update(status: 'pending')
        flash[:message] = "Investment marked as pending!"
      else
        flash[:error] = "Failed to mark investment as pending."
      end

      redirect_to admin.path(:show, id: investment.id)
    end
  end

  def approve
    investment = Investment.find(params[:id])
    investment.status = 'approved'
    investment.save
    redirect_to admin.path(:show, id: investment.id)
  end

  routes do
    put :mark_received, on: :member
    put :mark_pending, on: :member
    put :approve, on: :member
  end
end