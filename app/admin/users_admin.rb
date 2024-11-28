Trestle.resource(:users) do
  menu do
    item :users, icon: "fa fa-users"
  end

  table do
    column :id
    column :email
    column :role
    column :created_at, align: :center
    actions
  end

  form do |user|
    text_field :email
    text_field :role

    if user.new_record?
      password_field :password
    else
      password_field :password, label: "Change Password (leave blank if not changing)"
    end
  end

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete(:password)
      end
      super
    end
  end
end