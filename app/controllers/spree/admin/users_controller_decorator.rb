Spree::Admin::UsersController.class_eval do

  def create
    current_supplier = try_spree_current_user.supplier
    @user = Spree.user_class.new(user_params)
    @user.supplier = current_supplier
    if @user.save
      set_roles
      set_stock_locations

      flash[:success] = Spree.t(:created_successfully)
      redirect_to edit_admin_user_url(@user)
    else
      load_roles
      load_stock_locations

      flash.now[:error] = @user.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def wallet
    @payment_method = Spree::PaymentMethod.find_by(type: 'Spree::Gateway::StripeGateway', deleted_at: nil)
  end

  def wallets_actions
    @user = Spree::User.find(params[:id])
    wallet_payment_source = Spree::WalletPaymentSource.find(params[:order][:wallet_payment_source_id])

    if params[:submit] == 'change_default_payment'
      @user.wallet.default_wallet_payment_source = wallet_payment_source
      if @user.save
        flash[:success] = I18n.t('spree.admin.user.payment_wallet.actions.successfully_change_default_payment')
        redirect_to spree.wallets_admin_user_path(@user) and return
      else
        flash[:error] = I18n.t('spree.admin.user.payment_wallet.actions.error_change_default_payment')
        redirect_to spree.wallets_admin_user_path(@user) and return
      end
    elsif params[:submit] == 'remove_card'
      if wallet_payment_source.destroy
        flash[:success] = I18n.t('spree.admin.user.payment_wallet.actions.successfully_card_removed')
        redirect_to spree.wallets_admin_user_path(@user) and return
      else
        flash[:error] = I18n.t('spree.admin.user.payment_wallet.actions.error_card_removed')
        redirect_to spree.wallets_admin_user_path(@user) and return
      end
    end
  end

  def addcard

    use_existing_card = params[:use_existing_card].present?  ? params[:use_existing_card]: 'not'
    wallet_payment_source_id = params[:order].present?  ? params[:order][:wallet_payment_source_id]: nil
    payment_source = params[:payment_source].present?  ? params[:payment_source]["6"]: nil

    token = params[:card].present? ? params[:card][:token]: nil

    if token != '0000'
      user_wallet = @user.wallet
      begin
        customer = Stripe::Customer.create(description: @user.email, email: @user.email)
        card = customer.sources.create(source: token)
        method = Spree::PaymentMethod.find_by(type: 'Spree::PaymentMethod::StripeCreditCard', deleted_at: nil)
        credit_card = Spree::CreditCard.new(month: card.exp_month, year: card.exp_year, cc_type: card.brand.downcase,
                                              last_digits: card.last4, gateway_customer_profile_id: customer.id, gateway_payment_profile_id: card.id,
                                              name: params.require(:payment_source)["6"][:name], user_id: @user.id, payment_method_id: method.id)

        credit_card.save!
        user_wallet.add(credit_card)
        # Create wallet record
        wallet_payment_source =  user_wallet.add(credit_card)
        user_wallet.default_wallet_payment_source = wallet_payment_source
        if @user.save
            flash[:success] = I18n.t("spree.admin.user.payment_wallet.actions.success_add_card")
            redirect_to spree.wallets_admin_user_path(@user)
        else
            flash[:error] = @user.errors.full_messages.to_sentence
            redirect_to spree.wallets_admin_user_path(@user)
        end

      rescue Stripe::CardError => e
        flash[:error] = I18n.t('spree.admin.user.payment_wallet.actions.error_add_card')
        redirect_to spree.wallets_admin_user_path(@user)
      end
    else
      flash[:error] = I18n.t('spree.admin.user.payment_wallet.actions.error_add_card')
      redirect_to spree.wallets_admin_user_path(@user)
    end

  end

  private

  def build_resource
    current_supplier = try_spree_current_user.supplier

    if parent?
      parent.send(controller_name).build
    else
      model_class.new(supplier: current_supplier)
    end
  end

end
