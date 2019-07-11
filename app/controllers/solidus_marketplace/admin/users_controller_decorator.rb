module SolidusMarketplace
  module Admin
    module UsersControllerDecorator
      extend ActiveSupport::Concern

      included do
        prepend(InstanceMethods)
      end


      module InstanceMethods
        def create
          current_supplier = try_spree_current_user.supplier
          @user = Spree.user_class.new(user_params)
          @user.supplier = current_supplier

          if @user.save
            set_roles
            set_stock_locations

            flash[:success] = t('spree.created_successfully')
            redirect_to edit_admin_user_url(@user)
          else
            load_roles
            load_stock_locations

            flash.now[:error] = @user.errors.full_messages.join(", ")
            render :new, status: :unprocessable_entity
          end
        end

        def wallet
          @payment_method = Spree::PaymentMethod.find_by(type: 'Spree::Gateway::StripeGateway',
                                                         deleted_at: nil)
        end

        def removewallet
          @payment_method = Spree::PaymentMethod.find_by(type: 'Spree::Gateway::StripeGateway',
                                                         deleted_at: nil)
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
    end
  end
end
