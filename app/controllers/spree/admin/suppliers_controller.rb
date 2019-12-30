class Spree::Admin::SuppliersController < Spree::Admin::ResourceController

  def update
    @object.address = Spree::Address.immutable_merge(@object.address, permitted_resource_params[:address_attributes])

    if @object.update_attributes(permitted_resource_params.except(:address_attributes))
      respond_with(@object) do |format|
        format.html do
          flash[:success] = flash_message_for(@object, :successfully_updated)
          redirect_to location_after_save
        end
        format.js { render layout: false }
      end
    else
      respond_with(@object) do |format|
        format.html do
          flash.now[:error] = @object.errors.full_messages.join(", ")
          render_after_update_error
        end
        format.js { render layout: false }
      end
    end
  end

  def edit
    @object.address = Spree::Address.build_default unless @object.address.present?
    respond_with(@object) do |format|
      format.html { render :layout => !request.xhr? }
      format.js   { render :layout => false }
    end
  end

  def new
    @object.address = Spree::Address.build_default
  end

  private

    def collection
      params[:q] ||= {}
      params[:q][:meta_sort] ||= "name.asc"
      @search = Spree::Supplier.ransack(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:orders_per_page])
    end

    def find_resource
      Spree::Supplier.friendly.find(params[:id])
    end

    def location_after_save
      spree.edit_admin_supplier_path(@object)
    end

end
